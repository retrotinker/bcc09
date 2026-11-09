/* atof.c - atof for bcc09's libc
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <stdlib.h>

double
atof(s)
const char *s;
{
   return strtod(s, (char **) 0);
}
