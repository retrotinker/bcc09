/* abs(i), labs(l): absolute values; each compiled separately (-DL_abs,
 * -DL_labs).  abs(INT_MIN) and labs(LONG_MIN) give themselves.
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <stdlib.h>

#ifdef L_abs
int
abs(i)
int i;
{
   return i < 0 ? -i : i;
}
#endif

#ifdef L_labs
long
labs(l)
long l;
{
   return l < 0 ? -l : l;
}
#endif
