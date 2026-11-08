/* atexit: functions for exit() to call, last registered first
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <stdlib.h>

#define MAXATEXIT 32		/* the C standard requires 32 */

extern void (*__cleanup)();

static void (*fns[MAXATEXIT])();
static int count;

static void
run(status)
int status;
{
   while (count > 0)
      (*fns[--count])();
}

int
atexit(fn)
void (*fn)();
{
   if (count >= MAXATEXIT)
      return -1;
   fns[count++] = fn;
   __cleanup = run;
   return 0;
}
