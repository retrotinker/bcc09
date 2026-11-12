/* time.h's functions but strftime(): each compiled separately (-DL_name).
 * The calendar is the proleptic Gregorian one, computed in longs (after
 * Howard Hinnant's days_from_civil and civil_from_days).
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <time.h>
#include <errno.h>

#define DAY	86400L

#ifdef L___days
/* the days from 1970-01-01 to y-m-d (m 1 to 12; d may be outside the
   month) */
long
__days(y, m, d)
long y;
int m, d;
{
   long era, yoe, doy, doe;

   if (m <= 2)
      y--;
   era = (y >= 0 ? y : y - 399) / 400;
   yoe = y - era * 400;
   doy = (153L * (m > 2 ? m - 3 : m + 9) + 2) / 5 + d - 1;
   doe = yoe * 365 + yoe / 4 - yoe / 100 + doy;
   return era * 146097L + doe - 719468L;
}
#endif

#ifdef L___civil
/* the date of a day from 1970-01-01, into tm's year, mon, mday, wday and
   yday */
void
__civil(z, tm)
long z;
struct tm *tm;
{
   long era, doe, yoe, y, doy, mp;
   int m;

   tm->tm_wday = (int) ((z % 7 + 11) % 7);	/* (1970-01-01: Thursday) */
   z += 719468L;
   era = (z >= 0 ? z : z - 146096L) / 146097L;
   doe = z - era * 146097L;
   yoe = (doe - doe / 1460 + doe / 36524L - doe / 146096L) / 365;
   y = yoe + era * 400;
   doy = doe - (365 * yoe + yoe / 4 - yoe / 100);
   mp = (5 * doy + 2) / 153;
   tm->tm_mday = (int) (doy - (153 * mp + 2) / 5 + 1);
   m = (int) (mp < 10 ? mp + 3 : mp - 9);
   if (m <= 2)
      y++;
   tm->tm_mon = m - 1;
   tm->tm_year = (int) (y - 1900);
   tm->tm_yday = (int) (z - 719468L - __days(y, 1, 1));
}
#endif

#ifdef L_gmtime
static struct tm tmbuf;

struct tm *
gmtime(t)
const time_t *t;
{
   long days = *t / DAY, secs = *t % DAY;

   if (secs < 0)
   {
      secs += DAY;
      days--;
   }
   __civil(days, &tmbuf);
   tmbuf.tm_hour = (int) (secs / 3600);
   tmbuf.tm_min = (int) (secs / 60 % 60);
   tmbuf.tm_sec = (int) (secs % 60);
   tmbuf.tm_isdst = 0;
   return &tmbuf;
}
#endif

#ifdef L_localtime
struct tm *
localtime(t)
const time_t *t;
{
   return gmtime(t);		/* (no time zone: UTC) */
}
#endif

#ifdef L_mktime
/* q = n / d, n = n % d, both floored (so 0 <= n < d) */
static long
carry(n, d)
long *n;
long d;
{
   long q = *n / d;

   *n %= d;
   if (*n < 0)
   {
      *n += d;
      q--;
   }
   return q;
}

time_t
mktime(tm)
struct tm *tm;
{
   long sec = tm->tm_sec, min = tm->tm_min, hour = tm->tm_hour;
   long mon = tm->tm_mon, year = tm->tm_year + 1900L, days, t;
   time_t r;

   min += carry(&sec, 60L);
   hour += carry(&min, 60L);
   days = carry(&hour, 24L);
   year += carry(&mon, 12L);
   days += __days(year, (int) mon + 1, 1) + tm->tm_mday - 1;
   sec += hour * 3600 + min * 60;	/* (0 to 86399) */
   /* a long holds 1901-12-13 20:45:52 (day -24856, 74752 s) to
      2038-01-19 03:14:07 (day 24855, 11647 s) */
   if (days < -24856L || days > 24855L || (days == -24856L && sec < 74752L)
       || (days == 24855L && sec > 11647L))
      return (time_t) -1;
   if (days < 0)
      t = (days + 1) * DAY + (sec - DAY);	/* (no overflow on day -24856) */
   else
      t = days * DAY + sec;
   r = t;
   *tm = *gmtime(&r);
   return r;
}
#endif

#ifdef L_difftime
double
difftime(t1, t0)
time_t t1, t0;
{
   return (double) t1 - (double) t0;
}
#endif

#ifdef L_clock
clock_t
clock()
{
   return (clock_t) -1;		/* (no clock of the processor's time) */
}
#endif

#ifdef L_asctime
static char *names = "SunMonTueWedThuFriSat"
   "JanFebMarAprMayJunJulAugSepOctNovDec";

/* n in decimal, at least w digits (with c before: '0' or ' ') */
static char *
num(p, n, w, c)
char *p;
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
      *p++ = '-';
   while (w-- > i)
      *p++ = c;
   while (i > 0)
      *p++ = d[--i];
   return p;
}

static char *
name(p, i, n)
char *p;
int i, n;
{
   char *s = i >= 0 && i < n ? names + (n == 7 ? 0 : 21) + 3 * i : "???";

   *p++ = s[0];
   *p++ = s[1];
   *p++ = s[2];
   return p;
}

/* "Sun Sep 16 01:03:52 1973\n", as C89's sprintf() form gives it */
char *
asctime(tm)
const struct tm *tm;
{
   static char buf[40];
   char *p = buf;

   p = name(p, tm->tm_wday, 7);
   *p++ = ' ';
   p = name(p, tm->tm_mon, 12);
   p = num(p, (long) tm->tm_mday, 3, ' ');
   *p++ = ' ';
   p = num(p, (long) tm->tm_hour, 2, '0');
   *p++ = ':';
   p = num(p, (long) tm->tm_min, 2, '0');
   *p++ = ':';
   p = num(p, (long) tm->tm_sec, 2, '0');
   *p++ = ' ';
   p = num(p, tm->tm_year + 1900L, 0, ' ');
   *p++ = '\n';
   *p = 0;
   return buf;
}
#endif

#ifdef L_ctime
char *
ctime(t)
const time_t *t;
{
   return asctime(localtime(t));
}
#endif
