/* strcspn.c - for bcc09's libc
 *
 * Written for bcc09, to replace dev86's version, which had no license.
 * Like the rest of libc, it is distributed under the GNU Library General
 * Public License, version 2 (see COPYING.LIB).
 */

#include <string.h>

/* Return the length of the initial part of s that has none of the
   characters in reject (the whole of s if it has none of them). */
size_t
strcspn(s, reject)
const char *s;
const char *reject;
{
   register const char *p, *r;

   for (p = s; *p != '\0'; p++)
      for (r = reject; *r != '\0'; r++)
         if (*p == *r)
            return p - s;
   return p - s;
}
