/* setjmp.h - for bcc09's libc: setjmp(env) saves where it was called
 * from, and returns 0; longjmp(env, val) goes back there, so that that
 * setjmp() returns val (1 if val is 0).  The function that called
 * setjmp() must not have returned.  Local variables changed after the
 * setjmp() have their new values or the old (as C says; declare them
 * volatile, or keep them static, for the new).
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#ifndef __SETJMP_H
#define __SETJMP_H
#include <features.h>

typedef int jmp_buf[3];		/* S, the return address, U */

extern int setjmp __P ((jmp_buf));
extern void longjmp __P ((jmp_buf, int));

#endif
