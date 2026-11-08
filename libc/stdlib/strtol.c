/* strtol, strtoul: convert a string to a long, as the C standard says;
 * each compiled separately (-DL_strtol, -DL_strtoul)
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 * (dev86's accepted a digit equal to the base, didn't set endptr back to
 * the start when there were no digits, and ignored overflow.)
 */

#include <stdlib.h>
#include <ctype.h>
#include <errno.h>
#include <limits.h>

/* the value of an alphanumeric character as a digit, or 36 */
#define digit(c) (isdigit(c) ? (c) - '0' : \
		  isalpha(c) ? tolower(c) - 'a' + 10 : 36)

extern unsigned long __strtoul();

#ifdef L_strtoul
/* Convert nptr, setting *negp if it had a minus sign and *overp if the
   magnitude didn't fit, and return the magnitude (ULONG_MAX if it
   didn't fit). */
unsigned long
__strtoul(nptr, endptr, base, negp, overp)
const char *nptr;
char **endptr;
int base;
int *negp, *overp;
{
   register const char *p = nptr;
   register int d;
   unsigned long n, cutoff;
   int cutlim, any;

   *negp = *overp = 0;
   n = 0;
   any = 0;
   if (base < 0 || base == 1 || base > 36)
      goto done;
   while (isspace(*p))
      p++;
   if (*p == '-')
   {
      *negp = 1;
      p++;
   }
   else if (*p == '+')
      p++;
   /* "0x" is a prefix only if a hex digit follows it */
   if ((base == 0 || base == 16) && p[0] == '0'
       && (p[1] == 'x' || p[1] == 'X') && isxdigit(p[2]))
   {
      p += 2;
      base = 16;
   }
   else if (base == 0)
      base = (*p == '0') ? 8 : 10;

   cutoff = ULONG_MAX / base;
   cutlim = ULONG_MAX % base;
   for (;; p++)
   {
      d = digit(*p);
      if (d >= base)
	 break;
      any = 1;
      if (*overp || n > cutoff || (n == cutoff && d > cutlim))
	 *overp = 1;
      else
	 n = n * base + d;
   }
 done:
   if (endptr)
      *endptr = (char *) (any ? p : nptr);
   return *overp ? ULONG_MAX : n;
}

unsigned long
strtoul(nptr, endptr, base)
const char *nptr;
char **endptr;
int base;
{
   unsigned long n;
   int neg, over;

   n = __strtoul(nptr, endptr, base, &neg, &over);
   if (over)
   {
      errno = ERANGE;
      return ULONG_MAX;
   }
   return neg ? -n : n;
}
#endif

#ifdef L_strtol
long
strtol(nptr, endptr, base)
const char *nptr;
char **endptr;
int base;
{
   unsigned long n;
   int neg, over;

   n = __strtoul(nptr, endptr, base, &neg, &over);
   if (neg)
   {
      if (over || n > (unsigned long) LONG_MAX + 1)
      {
	 errno = ERANGE;
	 return LONG_MIN;
      }
      return -n;
   }
   if (over || n > LONG_MAX)
   {
      errno = ERANGE;
      return LONG_MAX;
   }
   return n;
}
#endif
