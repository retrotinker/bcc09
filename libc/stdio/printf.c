/* printf.c - the printf family, for bcc09's libc: each function compiled
 * separately (-DL_name)
 *
 * Written for bcc09 (dev86's printf.c had no license, and departed from
 * the C standard in several ways).  Like the rest of libc, it is
 * distributed under the GNU Library General Public License, version 2 (see
 * COPYING.LIB).
 *
 * The conversions are d, i, u, o, x, X, e, E, f, F, g, G, a, A, c, s, p,
 * n and %, with the flags -, +, space, # and 0, a width and a precision
 * (either may be *), and the sizes hh, h, l and L (a double: there is no
 * long double), as the C standard describes them; fpfmt.c does e, f, g
 * and a, through __fmtfp_hook, which xfpcvt.s sets only in a program that
 * has a printf with a floating point argument (bcc09 makes such a module
 * refer to __xfpcvt), so that others don't carry the code; without it,
 * these conversions print as they are written.
 * What the standard leaves to the implementation is as in the GNU C
 * library: %p is 0x and the hex digits, or (nil); %s of a null pointer is
 * (null); infinity and NaN are inf and nan (INF and NAN for E, F, G and A),
 * with a sign if negative; %a's first digit is 1 (0 for 0 and denormals,
 * as 0x0.0000000000001p-1022), and with no precision, its zeros at the
 * end are dropped (0x1p+0).
 */

#include <stdio.h>
#include <stdarg.h>
#include <string.h>

extern int __vformat();

#ifdef L___vformat
int (*__fmtfp_hook)();		/* __fmtfp, if it is linked (xfpcvt.s) */

#define F_MINUS	0x01		/* - */
#define F_PLUS	0x02		/* + */
#define F_SPACE	0x04		/* space */
#define F_HASH	0x08		/* # */
#define F_ZERO	0x10		/* 0 */

/* Convert fmt and the arguments, calling (*out)(c, arg) for each
   character, and return how many there were. */
int
__vformat(out, arg, fmt, ap)
void (*out)();
char *arg;
register const char *fmt;
va_list ap;
{
   int count = 0, flags, width, prec, size, len, zeros, pad, i, neg;
   int base, upper;
   unsigned long ul;
   unsigned int u;
   long l;
   char *s, *prefix;
   char digits[12];		/* 32 bits in octal, backwards */
   register char *d;

   for (; *fmt; fmt++)
   {
      if (*fmt != '%')
      {
	 (*out)(*fmt, arg);
	 count++;
	 continue;
      }

      /* flags, width, precision and size */
      flags = 0;
      for (;;)
      {
	 switch (*++fmt)
	 {
	 case '-': flags |= F_MINUS; continue;
	 case '+': flags |= F_PLUS; continue;
	 case ' ': flags |= F_SPACE; continue;
	 case '#': flags |= F_HASH; continue;
	 case '0': flags |= F_ZERO; continue;
	 }
	 break;
      }
      width = 0;
      if (*fmt == '*')
      {
	 width = va_arg(ap, int);
	 if (width < 0)
	 {
	    flags |= F_MINUS;
	    width = -width;
	 }
	 fmt++;
      }
      else
	 while (*fmt >= '0' && *fmt <= '9')
	    width = width * 10 + *fmt++ - '0';
      prec = -1;
      if (*fmt == '.')
      {
	 fmt++;
	 if (*fmt == '*')
	 {
	    prec = va_arg(ap, int);
	    if (prec < 0)
	       prec = -1;
	    fmt++;
	 }
	 else
	 {
	    prec = 0;
	    while (*fmt >= '0' && *fmt <= '9')
	       prec = prec * 10 + *fmt++ - '0';
	 }
      }
      size = 0;			/* int */
      if (*fmt == 'l')
      {
	 size = 1;		/* long */
	 fmt++;
	 if (*fmt == 'l')	/* (no long long: as long) */
	    fmt++;
      }
      else if (*fmt == 'L')	/* (long double is double) */
	 fmt++;
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

      neg = 0;
      prefix = "";
      base = 10;
      upper = 0;
      switch (*fmt)
      {
      case '\0':		/* the format ended in the middle */
	 fmt--;
	 continue;

      case 'd':
      case 'i':
	 if (size > 0)
	    l = va_arg(ap, long);
	 else
	 {
	    i = va_arg(ap, int);
	    if (size == -1)
	       i = (short) i;
	    else if (size == -2)
	       i = (signed char) i;
	    l = i;
	 }
	 if (l < 0)
	 {
	    neg = 1;
	    ul = -(unsigned long) l;
	 }
	 else
	    ul = l;
	 if (neg)
	    prefix = "-";
	 else if (flags & F_PLUS)
	    prefix = "+";
	 else if (flags & F_SPACE)
	    prefix = " ";
	 goto number;

      case 'o':
	 base = 8;
	 goto unsig;
      case 'X':
	 upper = 1;
      case 'x':
	 base = 16;
      case 'u':
       unsig:
	 if (size > 0)
	    ul = va_arg(ap, unsigned long);
	 else
	 {
	    u = va_arg(ap, unsigned int);
	    if (size == -1)
	       u = (unsigned short) u;
	    else if (size == -2)
	       u = (unsigned char) u;
	    ul = u;
	 }
	 if ((flags & F_HASH) && base == 16 && ul != 0)
	    prefix = upper ? "0X" : "0x";
	 goto number;

      case 'p':
	 s = va_arg(ap, char *);
	 if (s == 0)
	 {
	    s = "(nil)";
	    prec = -1;
	    goto string;
	 }
	 ul = (unsigned int) s;
	 base = 16;
	 prefix = "0x";
	 prec = -1;
	 flags &= ~F_ZERO;
       number:
	 /* the digits, backwards; none for 0 with a precision of 0 */
	 d = digits;
	 if ((ul >> 16) == 0)	/* (16 bits are quicker) */
	 {
	    for (u = ul; u != 0 || (d == digits && prec != 0); u /= base)
	       *d++ = "0123456789abcdef0123456789ABCDEF"[u % base + upper * 16];
	 }
	 else
	    for (; ul != 0; ul /= base)
	       *d++ = "0123456789abcdef0123456789ABCDEF"
		  [(int) (ul % base) + upper * 16];
	 len = d - digits;
	 zeros = (prec > len) ? prec - len : 0;
	 /* # with o: the first digit must be a 0 */
	 if ((flags & F_HASH) && base == 8 && zeros == 0
	     && (len == 0 || d[-1] != '0'))
	    zeros = 1;
	 i = strlen(prefix);
	 if ((flags & (F_ZERO | F_MINUS)) == F_ZERO && prec < 0
	     && width > i + zeros + len)
	    zeros = width - i - len;
	 pad = width - i - zeros - len;
	 if (!(flags & F_MINUS))
	    for (; pad > 0; pad--, count++)
	       (*out)(' ', arg);
	 for (; *prefix; prefix++, count++)
	    (*out)(*prefix, arg);
	 for (; zeros > 0; zeros--, count++)
	    (*out)('0', arg);
	 while (d > digits)
	 {
	    (*out)(*--d, arg);
	    count++;
	 }
	 for (; pad > 0; pad--, count++)
	    (*out)(' ', arg);
	 continue;

      case 'e':
      case 'E':
      case 'f':
      case 'F':
      case 'g':
      case 'G':
      case 'a':
      case 'A':
	 /* (the double's bytes: no floating point here) */
	 s = ap;
	 ap += sizeof(double);
	 if (__fmtfp_hook == 0)
	    goto other;
	 count += (*__fmtfp_hook)(out, arg, s, *fmt, flags, width, prec);
	 continue;

      case 'c':
	 digits[0] = va_arg(ap, int);
	 s = digits;
	 len = 1;
	 goto field;

      case 's':
	 s = va_arg(ap, char *);
	 if (s == 0)
	    s = "(null)";
       string:
	 /* up to prec characters */
	 for (len = 0; (prec < 0 || len < prec) && s[len]; len++)
	    ;
       field:
	 pad = width - len;
	 if (!(flags & F_MINUS))
	    for (; pad > 0; pad--, count++)
	       (*out)(' ', arg);
	 for (i = 0; i < len; i++, count++)
	    (*out)(s[i], arg);
	 for (; pad > 0; pad--, count++)
	    (*out)(' ', arg);
	 continue;

      case 'n':
	 if (size > 0)
	    *va_arg(ap, long *) = count;
	 else if (size == -1)
	    *va_arg(ap, short *) = count;
	 else if (size == -2)
	    *va_arg(ap, char *) = count;
	 else
	    *va_arg(ap, int *) = count;
	 continue;

      case '%':
	 (*out)('%', arg);
	 count++;
	 continue;

      default:			/* not a conversion: as it is */
       other:
	 (*out)('%', arg);
	 (*out)(*fmt, arg);
	 count += 2;
	 continue;
      }
   }
   return count;
}
#endif

#ifdef L_vfprintf
static void
fileout(c, fp)
int c;
FILE *fp;
{
   putc(c, fp);
}

int
vfprintf(fp, fmt, ap)
FILE *fp;
const char *fmt;
va_list ap;
{
   int n;

   n = __vformat(fileout, (char *) fp, fmt, ap);
   return ferror(fp) ? -1 : n;
}
#endif

#ifdef L_vprintf
int
vprintf(fmt, ap)
const char *fmt;
va_list ap;
{
   return vfprintf(stdout, fmt, ap);
}
#endif

#ifdef L_printf
int
printf(const char *fmt, ...)
{
   va_list ap;
   int n;

   va_start(ap, fmt);
   n = vfprintf(stdout, fmt, ap);
   va_end(ap);
   return n;
}
#endif

#ifdef L_fprintf
int
fprintf(FILE *fp, const char *fmt, ...)
{
   va_list ap;
   int n;

   va_start(ap, fmt);
   n = vfprintf(fp, fmt, ap);
   va_end(ap);
   return n;
}
#endif

#ifdef L_vsnprintf
/* into a string, keeping the last byte for the 0 */
struct strout
{
   char *p;
   size_t left;
};

static void
strout(c, so)
int c;
struct strout *so;
{
   if (so->left > 1)
   {
      *so->p++ = c;
      so->left--;
   }
}

int
vsnprintf(buf, n, fmt, ap)
char *buf;
size_t n;
const char *fmt;
va_list ap;
{
   struct strout so;
   int r;

   so.p = buf;
   so.left = n;
   r = __vformat(strout, (char *) &so, fmt, ap);
   if (n > 0)
      *so.p = '\0';
   return r;
}
#endif

#ifdef L_vsprintf
int
vsprintf(buf, fmt, ap)
char *buf;
const char *fmt;
va_list ap;
{
   return vsnprintf(buf, (size_t) -1, fmt, ap);
}
#endif

#ifdef L_sprintf
int
sprintf(char *buf, const char *fmt, ...)
{
   va_list ap;
   int n;

   va_start(ap, fmt);
   n = vsnprintf(buf, (size_t) -1, fmt, ap);
   va_end(ap);
   return n;
}
#endif

#ifdef L_snprintf
int
snprintf(char *buf, size_t size, const char *fmt, ...)
{
   va_list ap;
   int n;

   va_start(ap, fmt);
   n = vsnprintf(buf, size, fmt, ap);
   va_end(ap);
   return n;
}
#endif
