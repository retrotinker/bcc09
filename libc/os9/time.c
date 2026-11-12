/* time(t), on OS-9: its clock (F$Time: the year since 1900, month, day,
 * hours, minutes and seconds), as UTC; -1 if the call fails
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <time.h>
#include "os9.h"

time_t
time(t)
time_t *t;
{
   struct os9regs r;
   unsigned char now[6];
   struct tm tm;
   time_t res = (time_t) -1;

   OS9_CLEAR(&r);
   r.x = (unsigned) now;
   __os9call(&r, OS9_TIME);
   if (!OS9_FAILED(&r))
   {
      tm.tm_year = now[0];
      tm.tm_mon = now[1] - 1;
      tm.tm_mday = now[2];
      tm.tm_hour = now[3];
      tm.tm_min = now[4];
      tm.tm_sec = now[5];
      tm.tm_isdst = 0;
      res = mktime(&tm);
   }
   if (t)
      *t = res;
   return res;
}
