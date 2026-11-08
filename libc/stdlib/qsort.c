/* qsort: sort an array, with a Shell sort (no recursion, no extra memory)
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <stdlib.h>

void
qsort(base, nmemb, size, compar)
void *base;
size_t nmemb, size;
int (*compar)();
{
   register char *a, *b;
   size_t gap, i, j, k;
   char t;

   for (gap = nmemb / 2; gap > 0; gap /= 2)
      for (i = gap; i < nmemb; i++)
	 for (j = i; j >= gap; j -= gap)
	 {
	    a = (char *) base + (j - gap) * size;
	    b = (char *) base + j * size;
	    if ((*compar)(a, b) <= 0)
	       break;
	    for (k = 0; k < size; k++)
	    {
	       t = a[k];
	       a[k] = b[k];
	       b[k] = t;
	    }
	 }
}
