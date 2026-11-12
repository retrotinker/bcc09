/* abort(): raise(SIGABRT), which ends the program (with status 134, as
 * a Unix shell shows SIGABRT) unless a handler has been set; if one
 * returns, _exit(134) all the same.  Open files aren't flushed, and the
 * atexit() functions aren't called.
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <stdlib.h>
#include <signal.h>

void
abort()
{
   raise(SIGABRT);
   _exit(128 + SIGABRT);
}
