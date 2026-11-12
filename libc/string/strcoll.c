/* strcoll(a, b), strxfrm(to, from, n): in the "C" locale, collating is
 * comparing (strcmp), and the transformed string is the string; each
 * compiled separately (-DL_strcoll, -DL_strxfrm)
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <string.h>

#ifdef L_strcoll
int
strcoll(a, b)
const char *a, *b;
{
   return strcmp(a, b);
}
#endif

#ifdef L_strxfrm
size_t
strxfrm(to, from, n)
char *to;
const char *from;
size_t n;
{
   size_t len = strlen(from);

   if (len < n)
      strcpy(to, from);
   return len;
}
#endif
