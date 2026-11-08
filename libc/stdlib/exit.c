/* exit(status): call the functions registered with atexit(), then end
 * the program with _exit() (see _exit.s).  crt0 calls it when main
 * returns.
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <stdlib.h>

void (*__cleanup)() = 0;	/* set by atexit() */

void
exit(status)
int status;
{
   if (__cleanup)
      (*__cleanup)(status);
   _exit(status);
}
