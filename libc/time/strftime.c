/* strftime(s, max, format, tm), in the "C" locale: C89's conversions (%a
 * %A %b %B %c %d %H %I %j %m %M %p %S %U %w %W %x %X %y %Y %Z %%) and
 * C99's %C %D %e %F %h %n %R %t %T %u; %Z gives nothing (no time zone is
 * known).  The count of characters put in s, but its 0, or 0 if they and
 * the 0 don't fit in max (s is then undefined).
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <time.h>

static char *days[] = { "Sunday", "Monday", "Tuesday", "Wednesday",
			"Thursday", "Friday", "Saturday" };
static char *months[] = { "January", "February", "March", "April", "May",
			  "June", "July", "August", "September", "October",
			  "November", "December" };

static char *out, *end;		/* where the next character goes; s + max */

static void
put(c)
int c;
{
   if (out < end)
      *out = c;
   out++;
}

static void
puts1(s, n)
char *s;
int n;				/* (0: all of it) */
{
   if (n == 0)
      n = -1;
   while (*s && n-- != 0)
      put(*s++);
}

/* n in decimal, at least w digits, with c before (0: none) */
static void
num(n, w, c)
long n;
int w, c;
{
   char d[12];
   int i = 0;
   unsigned long u = n < 0 ? -n : n;

   do
      d[i++] = '0' + u % 10;
   while ((u /= 10) != 0);
   if (n < 0)
      put('-');
   while (c && w-- > i)
      put(c);
   while (i > 0)
      put(d[--i]);
}

static char *
name(names, i, n)
char **names;
int i, n;
{
   return i >= 0 && i < n ? names[i] : "?";
}

static void
format(f, tm)
const char *f;
const struct tm *tm;
{
   long year = tm->tm_year + 1900L;
   int h12;

   for (; *f; f++)
   {
      if (*f != '%')
      {
	 put(*f);
	 continue;
      }
      switch (*++f)
      {
      case 'a':
	 puts1(name(days, tm->tm_wday, 7), 3);
	 break;
      case 'A':
	 puts1(name(days, tm->tm_wday, 7), 0);
	 break;
      case 'b':
      case 'h':
	 puts1(name(months, tm->tm_mon, 12), 3);
	 break;
      case 'B':
	 puts1(name(months, tm->tm_mon, 12), 0);
	 break;
      case 'c':
	 format("%a %b %e %H:%M:%S %Y", tm);
	 break;
      case 'C':
	 num(year / 100, 2, '0');
	 break;
      case 'd':
	 num((long) tm->tm_mday, 2, '0');
	 break;
      case 'D':
      case 'x':
	 format("%m/%d/%y", tm);
	 break;
      case 'e':
	 num((long) tm->tm_mday, 2, ' ');
	 break;
      case 'F':
	 format("%Y-%m-%d", tm);
	 break;
      case 'H':
	 num((long) tm->tm_hour, 2, '0');
	 break;
      case 'I':
	 h12 = tm->tm_hour % 12;
	 num((long) (h12 ? h12 : 12), 2, '0');
	 break;
      case 'j':
	 num(tm->tm_yday + 1L, 3, '0');
	 break;
      case 'm':
	 num(tm->tm_mon + 1L, 2, '0');
	 break;
      case 'M':
	 num((long) tm->tm_min, 2, '0');
	 break;
      case 'n':
	 put('\n');
	 break;
      case 'p':
	 puts1(tm->tm_hour < 12 ? "AM" : "PM", 0);
	 break;
      case 'R':
	 format("%H:%M", tm);
	 break;
      case 'S':
	 num((long) tm->tm_sec, 2, '0');
	 break;
      case 't':
	 put('\t');
	 break;
      case 'T':
      case 'X':
	 format("%H:%M:%S", tm);
	 break;
      case 'u':
	 num(tm->tm_wday ? (long) tm->tm_wday : 7L, 0, 0);
	 break;
      case 'U':
	 num((tm->tm_yday + 7L - tm->tm_wday) / 7, 2, '0');
	 break;
      case 'w':
	 num((long) tm->tm_wday, 0, 0);
	 break;
      case 'W':
	 num((tm->tm_yday + 7L - (tm->tm_wday + 6) % 7) / 7, 2, '0');
	 break;
      case 'y':
	 num((year % 100 + 100) % 100, 2, '0');
	 break;
      case 'Y':
	 num(year, 0, 0);
	 break;
      case 'Z':
	 break;			/* (no time zone) */
      case '%':
	 put('%');
	 break;
      case 0:
	 f--;			/* (a lone % at the end) */
	 put('%');
	 break;
      default:			/* (not a conversion: as it is) */
	 put('%');
	 put(*f);
	 break;
      }
   }
}

size_t
strftime(s, max, f, tm)
char *s;
size_t max;
const char *f;
const struct tm *tm;
{
   out = s;
   end = s + max;
   format(f, tm);
   if (out >= end)
      return 0;
   *out = 0;
   return out - s;
}
