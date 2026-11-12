/* time(t), on FLEX: its date (the month, day and year at $CC0E, $CC0F
 * and $CC10, the year of two digits: 70 to 99 the 1900s, else the
 * 2000s), at midnight; -1 if it has no date (a month of 0)
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <time.h>

#define FLEXDATE	((unsigned char *) 0xcc0e)

time_t
time(t)
time_t *t;
{
   struct tm tm;
   time_t r = (time_t) -1;
   int y = FLEXDATE[2];

   if (FLEXDATE[0] >= 1 && FLEXDATE[0] <= 12)
   {
      tm.tm_sec = tm.tm_min = tm.tm_hour = 0;
      tm.tm_mday = FLEXDATE[1];
      tm.tm_mon = FLEXDATE[0] - 1;
      tm.tm_year = y >= 70 ? y : y + 100;
      tm.tm_isdst = 0;
      r = mktime(&tm);
   }
   if (t)
      *t = r;
   return r;
}
