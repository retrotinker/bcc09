/* fpfmt.c - printf's %e, %f and %g, for bcc09's libc
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 *
 * The double is read as its bits, and its decimal digits are exact: the
 * integer part divided by 100 over and over, the fraction multiplied by
 * 10, in big integers (bignum.c), then rounded to the nearest, to even
 * on a tie, as the GNU C library does.  So no floating point arithmetic
 * is needed here (nor its helpers linked).  At most DIGMAX digits are
 * worked out; any more (%.400f, say) are printed as zeros.
 */

#include <string.h>
#include "../stdlib/bignum.h"

#define DIGMAX	340

/* Put in buf the decimal digits (values 0 to 9) of the finite double
   whose big-endian bytes are at d (the sign is ignored): for mode 'f',
   to prec places after the point; for 'e', prec + 1 digits from the
   first that isn't 0.  *decpt says where the point goes (the value is
   0.DIGITS * 10^*decpt), *pad how many zeros follow the digits returned
   (if there were more than DIGMAX). */
static int
digits(d, mode, prec, buf, decpt, pad)
unsigned char *d;
int mode, prec;
char *buf;
int *decpt, *pad;
{
   union
   {
      struct __bn i;		/* the integer part */
      unsigned char f[140];	/* the fraction, f[0] the lowest byte */
   } u;
   unsigned char m[7];
   int e, i, j, k, n, nb, need, round, sticky, dg;
   unsigned t;

   e = (d[0] & 0x7f) << 4 | d[1] >> 4;
   m[0] = d[1] & 0x0f;
   for (i = 2; i < 8; i++)
      m[i - 1] = d[i];
   if (e)
      m[0] |= 0x10;
   else
      e = 1;
   e -= 1075;			/* the value is m * 2^e */

   *pad = 0;
   for (i = 0; i < 7 && m[i] == 0; i++)
      ;
   if (i == 7)
   {
      /* 0: as 0. and zeros */
      *decpt = 1;
      need = prec + 1;		/* ('f': one before the point) */
      if (need > DIGMAX)
      {
	 *pad = need - DIGMAX;
	 need = DIGMAX;
      }
      for (i = 0; i < need; i++)
	 buf[i] = 0;
      return need;
   }

   /* the integer part's digits, the last first, then turned around */
   __bnset(&u.i, m, 7);
   if (e >= 0)
      __bnshl(&u.i, e);
   else
      __bnshr(&u.i, -e);
   n = 0;
   while (u.i.n)
   {
      t = __bndivs(&u.i, 100);
      buf[n++] = t % 10;
      buf[n++] = t / 10;
   }
   while (n > 0 && buf[n - 1] == 0)
      n--;
   for (i = 0, j = n - 1; i < j; i++, j--)
   {
      k = buf[i];
      buf[i] = buf[j];
      buf[j] = k;
   }
   *decpt = n;

   /* the fraction: m's low -e bits, as bytes of a fraction f / 256^nb */
   k = e < 0 ? -e : 0;
   nb = (k + 7) >> 3;
   for (i = 0; i < nb; i++)
      u.f[i] = 0;
   if (k)
   {
      /* m << (8 nb - k): its low nb bytes are the fraction */
      t = 0;
      j = 8 * nb - k;
      for (i = 0; i < 7 && i < nb; i++)
      {
	 t = (m[6 - i] << j) | t;
	 u.f[i] = t;
	 t >>= 8;
      }
      if (i < nb)
	 u.f[i] = t;
   }

   need = mode == 'f' ? n + prec : prec + 1;
   if (n > need + 1)
      n = need + 1;		/* ('e' with a long integer part) */
   if (need >= DIGMAX)
   {
      *pad = need - (DIGMAX - 1);
      need = DIGMAX - 1;
   }
   sticky = 0;
   /* (digits of the integer part past need + 1 are in buf too; the sticky
      bit is any of them that isn't 0) */
   for (i = need + 1; i < *decpt && i < DIGMAX; i++)
      if (buf[i])
	 sticky = 1;

   /* the fraction's digits, to need + 1 (one more, to round by); for 'e',
      without the zeros before the first that isn't */
   while (n < need + 1)
   {
      t = 0;			/* the fraction times 10: the digit */
      for (i = 0; i < nb; i++)	/* comes out the top */
      {
	 t = u.f[i] * 10 + t;
	 u.f[i] = t;
	 t >>= 8;
      }
      dg = t;
      if (mode == 'e' && n == 0 && dg == 0)
      {
	 --*decpt;
	 continue;
      }
      buf[n++] = dg;
   }
   for (i = 0; i < nb; i++)
      if (u.f[i])
	 sticky = 1;

   /* round to need digits */
   if (*pad)
      return need;		/* (no longer exact anyway) */
   round = buf[need];
   if (round > 5 || (round == 5 &&
		     (sticky || (need > 0 && (buf[need - 1] & 1)))))
   {
      for (i = need - 1; i >= 0 && buf[i] == 9; i--)
	 buf[i] = 0;
      if (i >= 0)
	 buf[i]++;
      else
      {
	 /* all 9s: a 1, then zeros, and the point one place on */
	 for (i = need; i > 0; i--)
	    buf[i] = buf[i - 1];
	 buf[0] = 1;
	 ++*decpt;
	 if (mode == 'f')
	    need++;
      }
   }
   return need;
}

/* the digit at i, as a character: 0 before the first, and past the end */
static int
dchar(buf, n, i)
char *buf;
int n, i;
{
   return i >= 0 && i < n ? buf[i] + '0' : '0';
}

#define F_MINUS	0x01
#define F_PLUS	0x02
#define F_SPACE	0x04
#define F_HASH	0x08
#define F_ZERO	0x10

static void
rep(out, arg, c, n)
void (*out)();
char *arg;
int c, n;
{
   for (; n > 0; n--)
      (*out)(c, arg);
}

/* print the double whose bytes are at d by conversion c (e, E, f, F, g
   or G), with printf's flags, width and precision (-1 for none), by
   calling (*out)(c, arg) for each character; return how many */
int
__fmtfp(out, arg, d, c, flags, width, prec)
void (*out)();
char *arg;
unsigned char *d;
int c, flags, width, prec;
{
   char buf[DIGMAX + 1];
   char *sign, *s;
   int upper, n, decpt, pad, mode, ilen, flen, dot, x, xlen, len, i, g;
   char xbuf[6];

   upper = (c == 'E' || c == 'F' || c == 'G');
   c |= 0x20;			/* (lower case) */
   sign = (d[0] & 0x80) ? "-" : (flags & F_PLUS) ? "+" :
      (flags & F_SPACE) ? " " : "";

   /* infinity and NaN */
   if ((d[0] & 0x7f) == 0x7f && (d[1] & 0xf0) == 0xf0)
   {
      s = (d[1] & 0x0f) | d[2] | d[3] | d[4] | d[5] | d[6] | d[7] ?
	 (upper ? "NAN" : "nan") : (upper ? "INF" : "inf");
      len = strlen(sign) + 3;
      if (!(flags & F_MINUS))
	 rep(out, arg, ' ', width - len);
      for (; *sign; sign++)
	 (*out)(*sign, arg);
      for (i = 0; i < 3; i++)
	 (*out)(s[i], arg);
      if (flags & F_MINUS)
	 rep(out, arg, ' ', width - len);
      return width > len ? width : len;
   }

   if (prec < 0)
      prec = 6;
   g = (c == 'g');
   mode = c;
   if (g)
   {
      /* %e's exponent with prec significant digits decides */
      if (prec == 0)
	 prec = 1;
      digits(d, 'e', prec - 1, buf, &decpt, &pad);
      x = decpt - 1;
      if (x < prec && x >= -4)
      {
	 mode = 'f';
	 prec = prec - 1 - x;
      }
      else
      {
	 mode = 'e';
	 prec = prec - 1;
      }
   }
   n = digits(d, mode, prec, buf, &decpt, &pad);
   n += pad;			/* (dchar gives the zeros) */

   /* the parts: ilen digits, a point if dot, flen digits, then the
      exponent */
   if (mode == 'f')
   {
      ilen = decpt > 0 ? decpt : 1;
      flen = prec;
      x = 0;
   }
   else
   {
      ilen = 1;
      flen = prec;
      x = decpt - 1;
   }
   if (g && !(flags & F_HASH))	/* %g drops zeros at the end */
      while (flen > 0 &&
	     dchar(buf, n - pad, (mode == 'f' ? decpt : 1) + flen - 1)
	     == '0')
	 flen--;
   dot = flen > 0 || (flags & F_HASH);
   xlen = 0;
   if (mode == 'e')
   {
      i = x < 0 ? -x : x;
      xbuf[xlen++] = upper ? 'E' : 'e';
      xbuf[xlen++] = x < 0 ? '-' : '+';
      if (i >= 100)
	 xbuf[xlen++] = '0' + i / 100;
      xbuf[xlen++] = '0' + i / 10 % 10;
      xbuf[xlen++] = '0' + i % 10;
   }
   len = strlen(sign) + ilen + dot + flen + xlen;

   /* and out, padded */
   if (!(flags & (F_MINUS | F_ZERO)))
      rep(out, arg, ' ', width - len);
   for (s = sign; *s; s++)
      (*out)(*s, arg);
   if ((flags & (F_MINUS | F_ZERO)) == F_ZERO)
      rep(out, arg, '0', width - len);
   n -= pad;
   if (mode == 'f')
   {
      if (decpt > 0)
	 for (i = 0; i < decpt; i++)
	    (*out)(dchar(buf, n, i), arg);
      else
	 (*out)('0', arg);
      if (dot)
	 (*out)('.', arg);
      for (i = 0; i < flen; i++)
	 (*out)(dchar(buf, n, decpt + i), arg);
   }
   else
   {
      (*out)(dchar(buf, n, 0), arg);
      if (dot)
	 (*out)('.', arg);
      for (i = 0; i < flen; i++)
	 (*out)(dchar(buf, n, 1 + i), arg);
      for (i = 0; i < xlen; i++)
	 (*out)(xbuf[i], arg);
   }
   if (flags & F_MINUS)
      rep(out, arg, ' ', width - len);
   return width > len ? width : len;
}
