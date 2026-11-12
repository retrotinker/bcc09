/* signal(sig, func), raise(sig): signals as C has them, raised only by
 * raise() (signal.h); each compiled separately (-DL_signal, -DL_raise),
 * the handlers in signal's module
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <signal.h>
#include <stdlib.h>
#include <errno.h>

extern __sighandler_t __sigtab[];

#ifdef L_signal
__sighandler_t __sigtab[_NSIG];	/* (SIG_DFL: 0) */

__sighandler_t
signal(sig, func)
int sig;
__sighandler_t func;
{
   __sighandler_t old;

   if (sig <= 0 || sig >= _NSIG || func == SIG_ERR)
   {
      errno = EINVAL;
      return SIG_ERR;
   }
   old = __sigtab[sig];
   __sigtab[sig] = func;
   return old;
}
#endif

#ifdef L_raise
int
raise(sig)
int sig;
{
   __sighandler_t func;

   if (sig <= 0 || sig >= _NSIG)
   {
      errno = EINVAL;
      return -1;
   }
   func = __sigtab[sig];
   if (func == SIG_IGN)
      return 0;
   if (func == SIG_DFL)
      _exit(128 + sig);
   __sigtab[sig] = SIG_DFL;	/* (as C allows: the handler may set it again) */
   (*func)(sig);
   return 0;
}
#endif
