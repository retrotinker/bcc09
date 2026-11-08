/* itoa(i): i in decimal, in a static buffer (not in the C standard)
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <stdlib.h>

char *
itoa(i)
int i;
{
   static char buf[7];		/* "-32768" */
   register char *p = buf + sizeof(buf) - 1;
   register unsigned u = i;

   if (i < 0)
      u = -u;			/* unsigned, so -32768 works */
   *p = '\0';
   do
   {
      *--p = '0' + u % 10;
      u /= 10;
   }
   while (u);
   if (i < 0)
      *--p = '-';
   return p;
}
