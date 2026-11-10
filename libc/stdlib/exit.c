/* exit(status): call the functions registered with atexit(), last
 * first, then flush and close the stdio streams (if the program uses
 * stdio, which sets __stdio_exit), then end the program with _exit()
 * (see _exit.s), as the C standard says.  crt0 calls it when main
 * returns.
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <stdlib.h>

void (*__cleanup)() = 0;	/* set by atexit() */
void (*__stdio_exit)() = 0;	/* set by stdio */

void
exit(status)
int status;
{
   if (__cleanup)
      (*__cleanup)(status);
   if (__stdio_exit)
      (*__stdio_exit)();
   _exit(status);
}
