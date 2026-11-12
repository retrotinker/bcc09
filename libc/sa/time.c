/* time(t): no clock on this system: -1 (and *t too, if t isn't NULL)
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <time.h>

time_t
time(t)
time_t *t;
{
   if (t)
      *t = (time_t) -1;
   return (time_t) -1;
}
