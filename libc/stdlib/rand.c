/* rand, srand: the portable generator given as an example in the C
 * standard; each compiled separately (-DL_rand, -DL_srand)
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <stdlib.h>

extern unsigned long __rand_next;

#ifdef L_rand
unsigned long __rand_next = 1;

int
rand()
{
   __rand_next = __rand_next * 1103515245L + 12345;
   return (unsigned int) (__rand_next / 65536) % 32768;
}
#endif

#ifdef L_srand
void
srand(seed)
unsigned int seed;
{
   __rand_next = seed;
}
#endif
