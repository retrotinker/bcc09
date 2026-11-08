/* scanf.c - the scanf family, for bcc09's libc: each function compiled
 * separately (-DL_name)
 *
 * Written for bcc09 (dev86's scanf.c had no license).  Like the rest of
 * libc, it is distributed under the GNU Library General Public License,
 * version 2 (see COPYING.LIB).
 *
 * The conversions are d, i, u, o, x, X, c, s, [, p, n and %, with * (no
 * assignment), a width, and the sizes hh, h and l, as the C standard
 * describes them.  There is no floating point yet.  What the standard
 * leaves to the implementation is as in the GNU C library: a range such as
 * a-z in a [ set; %p reads what printf's %p writes (but not (nil)); and a
 * failure to read before anything has been assigned returns EOF.
 */

#include <stdio.h>
#include <stdarg.h>
#include <ctype.h>
#include <string.h>

/* where the characters come from: a FILE, or a string if fp is 0 */
struct __scan
{
   FILE *fp;
   const char *s;
   int count;			/* characters read, for %n */
};

extern int __vscan();

#ifdef L___vscan

#define NONE	(-2)		/* no character: the width was used up */

static int
get(sc)
struct __scan *sc;
{
   int c;

   if (sc->fp)
      c = getc(sc->fp);
   else if (*sc->s)
      c = (unsigned char) *sc->s++;
   else
      c = EOF;
   if (c != EOF)
      sc->count++;
   return c;
}

/* put back c, the last character got (if any) */
static void
unget(c, sc)
int c;
struct __scan *sc;
{
   if (c < 0)
      return;
   sc->count--;
   if (sc->fp)
      ungetc(c, sc->fp);
   else
      sc->s--;
}

/* skip white space, and return the next character (still to be read) */
static int
skipspace(sc)
struct __scan *sc;
{
   int c;

   while ((c = get(sc)) != EOF && isspace(c))
      ;
   unget(c, sc);
   return c;
}

/* the value of digit c, or 99 */
static int
digit(c)
int c;
{
   if (c >= '0' && c <= '9')
      return c - '0';
   if (c >= 'a' && c <= 'f')
      return c - 'a' + 10;
   if (c >= 'A' && c <= 'F')
      return c - 'A' + 10;
   return 99;
}

/* Read a number in base (0: as C does, 16: a 0x is allowed), of up to
   width characters, into *up; return 1, or 0 if there was none (a
   matching failure: a sign, or a 0x, with no digits after it is one, as
   in the GNU C library). */
static int
number(sc, width, base, up)
struct __scan *sc;
int width, base;
unsigned long *up;
{
   unsigned long ul = 0;
   int c, d, neg = 0, digits = 0;

#define NEXT()	(--width > 0 ? get(sc) : NONE)
   c = get(sc);
   if (c == '+' || c == '-')
   {
      neg = (c == '-');
      c = NEXT();
   }
   if ((base == 0 || base == 16) && c == '0')
   {
      digits = 1;
      c = NEXT();
      if (c == 'x' || c == 'X')
      {
	 base = 16;
	 digits = 0;		/* (0x needs a digit after it) */
	 c = NEXT();
      }
      else if (base == 0)
	 base = 8;
   }
   if (base == 0)
      base = 10;
   for (; c >= 0 && (d = digit(c)) < base; c = NEXT())
   {
      ul = ul * base + d;
      digits++;
   }
#undef NEXT
   unget(c, sc);
   if (digits == 0)
      return 0;
   *up = neg ? -ul : ul;
   return 1;
}

/* Read the input sc as fmt says, assigning to the pointers in ap, and
   return how many were assigned (EOF if the input ended first). */
int
__vscan(sc, fmt, ap)
struct __scan *sc;
register const char *fmt;
va_list ap;
{
   int assigned = 0, skip, width, size, base, c, n, r, neg;
   unsigned long ul;
   unsigned char set[32];	/* a bit for each character in a [ set */
   register char *p;

   for (; *fmt; fmt++)
   {
      if (isspace((unsigned char) *fmt))
      {
	 skipspace(sc);
	 continue;
      }
      if (*fmt != '%' || fmt[1] == '%')
      {
	 /* as it is (%% after white space) */
	 if (*fmt == '%')
	 {
	    fmt++;
	    skipspace(sc);
	 }
	 if ((c = get(sc)) == EOF)
	    goto input;
	 if (c != (unsigned char) *fmt)
	 {
	    unget(c, sc);
	    return assigned;
	 }
	 continue;
      }

      /* *, width and size */
      skip = 0;
      if (*++fmt == '*')
      {
	 skip = 1;
	 fmt++;
      }
      width = 0;
      while (*fmt >= '0' && *fmt <= '9')
	 width = width * 10 + *fmt++ - '0';
      size = 0;			/* int */
      if (*fmt == 'l')
      {
	 size = 1;		/* long */
	 fmt++;
	 if (*fmt == 'l')	/* (no long long: as long) */
	    fmt++;
      }
      else if (*fmt == 'h')
      {
	 size = -1;		/* short */
	 fmt++;
	 if (*fmt == 'h')
	 {
	    size = -2;		/* char */
	    fmt++;
	 }
      }

      base = 10;
      switch (*fmt)
      {
      case '\0':		/* the format ended in the middle */
	 return assigned;

      case 'n':
	 if (skip)
	    continue;
	 if (size > 0)
	    *va_arg(ap, long *) = sc->count;
	 else if (size == -1)
	    *va_arg(ap, short *) = sc->count;
	 else if (size == -2)
	    *va_arg(ap, char *) = sc->count;
	 else
	    *va_arg(ap, int *) = sc->count;
	 continue;

      case 'c':
	 if (width == 0)
	    width = 1;
	 p = skip ? 0 : va_arg(ap, char *);
	 for (n = 0; n < width && (c = get(sc)) != EOF; n++)
	    if (p)
	       *p++ = c;
	 if (n < width)
	    goto input;
	 break;

      case 's':
	 if (skipspace(sc) == EOF)
	    goto input;
	 p = skip ? 0 : va_arg(ap, char *);
	 for (n = 0; (width == 0 || n < width) && (c = get(sc)) != EOF; n++)
	 {
	    if (isspace(c))
	    {
	       unget(c, sc);
	       break;
	    }
	    if (p)
	       *p++ = c;
	 }
	 if (p)
	    *p = '\0';
	 break;

      case '[':
	 /* the set: ] first is in it, as is - first or last */
	 neg = (*++fmt == '^');
	 if (neg)
	    fmt++;
	 memset(set, 0, sizeof(set));
	 n = 1;			/* (the first) */
	 for (; *fmt && (*fmt != ']' || n); fmt++, n = 0)
	 {
	    c = (unsigned char) *fmt;
	    if (fmt[1] == '-' && fmt[2] && fmt[2] != ']'
		&& (unsigned char) fmt[2] >= c)
	    {
	       for (r = (unsigned char) fmt[2]; c <= r; c++)
		  set[c >> 3] |= 1 << (c & 7);
	       fmt += 2;
	    }
	    else
	       set[c >> 3] |= 1 << (c & 7);
	 }
	 if (*fmt == '\0')	/* (no ]: a bad format) */
	    return assigned;
	 p = skip ? 0 : va_arg(ap, char *);
	 for (n = 0; (width == 0 || n < width) && (c = get(sc)) != EOF; n++)
	 {
	    if (((set[c >> 3] >> (c & 7)) & 1) == neg)
	    {
	       unget(c, sc);
	       break;
	    }
	    if (p)
	       *p++ = c;
	 }
	 if (n == 0)
	 {
	    if (c == EOF)
	       goto input;
	    return assigned;
	 }
	 if (p)
	    *p = '\0';
	 break;

      case 'p':
	 size = 2;		/* (a pointer) */
      case 'x':
      case 'X':
	 base = 16;
	 goto num;
      case 'o':
	 base = 8;
	 goto num;
      case 'i':
	 base = 0;
      case 'd':
      case 'u':
       num:
	 if (skipspace(sc) == EOF)
	    goto input;
	 if (!number(sc, width ? width : 32767, base, &ul))
	    return assigned;
	 if (skip)
	    continue;
	 if (size == 2)
	    *va_arg(ap, char **) = (char *) (unsigned int) ul;
	 else if (size > 0)
	    *va_arg(ap, long *) = ul;
	 else if (size == -1)
	    *va_arg(ap, short *) = ul;
	 else if (size == -2)
	    *va_arg(ap, char *) = ul;
	 else
	    *va_arg(ap, int *) = ul;
	 break;

      default:			/* not a conversion */
	 return assigned;
      }
      if (!skip)
	 assigned++;
   }
   return assigned;

 input:
   return assigned ? assigned : EOF;
}
#endif

#ifdef L_vfscanf
int
vfscanf(fp, fmt, ap)
FILE *fp;
const char *fmt;
va_list ap;
{
   struct __scan sc;

   sc.fp = fp;
   sc.count = 0;
   return __vscan(&sc, fmt, ap);
}
#endif

#ifdef L_vscanf
int
vscanf(fmt, ap)
const char *fmt;
va_list ap;
{
   return vfscanf(stdin, fmt, ap);
}
#endif

#ifdef L_vsscanf
int
vsscanf(s, fmt, ap)
const char *s;
const char *fmt;
va_list ap;
{
   struct __scan sc;

   sc.fp = 0;
   sc.s = s;
   sc.count = 0;
   return __vscan(&sc, fmt, ap);
}
#endif

#ifdef L_scanf
int
scanf(const char *fmt, ...)
{
   va_list ap;
   int n;

   va_start(ap, fmt);
   n = vfscanf(stdin, fmt, ap);
   va_end(ap);
   return n;
}
#endif

#ifdef L_fscanf
int
fscanf(FILE *fp, const char *fmt, ...)
{
   va_list ap;
   int n;

   va_start(ap, fmt);
   n = vfscanf(fp, fmt, ap);
   va_end(ap);
   return n;
}
#endif

#ifdef L_sscanf
int
sscanf(const char *s, const char *fmt, ...)
{
   va_list ap;
   int n;

   va_start(ap, fmt);
   n = vsscanf(s, fmt, ap);
   va_end(ap);
   return n;
}
#endif
