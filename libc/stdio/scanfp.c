/* scanfp.c - scanf's %a, %e, %f and %g, for bcc09's libc (see scanf.c
 * and xfptvc.s)
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 *
 * As C says, the input taken is the longest that is, or begins, a number
 * as strtod reads one (decimal, hexadecimal, INF, INFINITY, NAN or
 * NAN(chars)), within the width; if that isn't a whole number ("1e+",
 * "0x", "infin"), it is a matching failure, as in the GNU C library.  At
 * most NBUF - 1 characters of it are converted.
 */

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include "scan.h"

#define NBUF	128

int
__scanfp(sc, width, p, isdouble)
struct __scan *sc;
int width;
char *p;
int isdouble;
{
   char buf[NBUF];
   char *end;
   int n = 0, c, i, hex = 0, digits = 0, point = 0;
   double d;
   static char infinity[] = "infinity", nan[] = "nan";

#define TAKE()	(n < NBUF - 1 ? buf[n++] = c : 0, --width)
#define NEXT()	(width > 0 ? (c = __scget(sc)) : (c = -2))

   NEXT();
   if (c == '+' || c == '-')
   {
      TAKE();
      NEXT();
   }
   if ((c | 0x20) == 'i' || (c | 0x20) == 'n')
   {
      /* INF, INFINITY, NAN, NAN(chars) */
      char *w = (c | 0x20) == 'i' ? infinity : nan;

      for (i = 0; w[i] && c >= 0 && (c | 0x20) == w[i]; i++)
      {
	 TAKE();
	 NEXT();
      }
      if (w == nan && i == 3 && c == '(')
      {
	 do
	 {
	    TAKE();
	    NEXT();
	 }
	 while (c >= 0 && (isalnum(c) || c == '_'));
	 if (c == ')')
	 {
	    TAKE();
	    NEXT();
	 }
      }
   }
   else
   {
      if (c == '0')
      {
	 TAKE();
	 NEXT();
	 digits = 1;
	 if ((c | 0x20) == 'x')
	 {
	    TAKE();
	    NEXT();
	    hex = 1;
	    digits = 0;
	 }
      }
      for (;;)
      {
	 if (c >= 0 && (hex ? isxdigit(c) : isdigit(c)))
	    digits++;
	 else if (c == '.' && !point)
	    point = 1;
	 else
	    break;
	 TAKE();
	 NEXT();
      }
      if (digits && (c | 0x20) == (hex ? 'p' : 'e'))
      {
	 TAKE();
	 NEXT();
	 if (c == '+' || c == '-')
	 {
	    TAKE();
	    NEXT();
	 }
	 while (c >= 0 && isdigit(c))
	 {
	    TAKE();
	    NEXT();
	 }
      }
   }
   __scunget(c, sc);		/* (not if it was EOF, or none) */
   buf[n] = '\0';

   /* a whole number? */
   d = strtod(buf, &end);
   if (n == 0 || *end != '\0')
      return 0;
   if (p)
   {
      if (isdouble)
	 *(double *) p = d;
      else
	 *(float *) p = d;
   }
   return 1;
}
