/* signal.h - for bcc09's libc: signals as C has them, raised only by
 * raise() (and abort(): SIGABRT), since none of bcc09's systems sends
 * them to a program.  signal(sig, func) sets what raise(sig) does: call
 * func(sig) (after setting it back to SIG_DFL, as C allows), nothing
 * (SIG_IGN), or end the program (SIG_DFL: _exit() with 128 + sig, as a
 * Unix shell shows a program that a signal ended).
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#ifndef __SIGNAL_H
#define __SIGNAL_H
#include <features.h>

typedef int sig_atomic_t;
typedef void (*__sighandler_t) __P ((int));

#define SIG_DFL	((__sighandler_t) 0)
#define SIG_IGN	((__sighandler_t) 1)
#define SIG_ERR	((__sighandler_t) -1)

#define SIGINT	2
#define SIGILL	4
#define SIGABRT	6
#define SIGFPE	8
#define SIGSEGV	11
#define SIGTERM	15
#define _NSIG	16		/* (signals are 1 to 15) */

extern __sighandler_t signal __P ((int, __sighandler_t));
extern int raise __P ((int));

#endif
