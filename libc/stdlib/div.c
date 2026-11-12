/* div(n, d), ldiv(n, d): the quotient and remainder, truncated toward
 * zero (as / and % are); each compiled separately (-DL_div, -DL_ldiv)
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <stdlib.h>

#ifdef L_div
div_t
div(n, d)
int n, d;
{
   div_t r;

   r.quot = n / d;
   r.rem = n % d;
   return r;
}
#endif

#ifdef L_ldiv
ldiv_t
ldiv(n, d)
long n, d;
{
   ldiv_t r;

   r.quot = n / d;
   r.rem = n % d;
   return r;
}
#endif
