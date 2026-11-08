/* bsearch: find a key in a sorted array
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <stdlib.h>

void *
bsearch(key, base, nmemb, size, compar)
const void *key;
const void *base;
size_t nmemb, size;
int (*compar)();
{
   size_t lo = 0, hi = nmemb, mid;
   register char *p;
   int c;

   while (lo < hi)
   {
      mid = lo + (hi - lo) / 2;
      p = (char *) base + mid * size;
      c = (*compar)(key, p);
      if (c == 0)
	 return p;
      if (c < 0)
	 hi = mid;
      else
	 lo = mid + 1;
   }
   return 0;
}
