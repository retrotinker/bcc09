/* assert.h - for bcc09's libc: assert(e) checks that e is true, and if
 * it isn't writes "file:line: assertion failed: e" to stderr and calls
 * abort(); with NDEBUG defined when assert.h is included, it does
 * nothing (and e isn't evaluated).  (No include guard: each inclusion
 * defines assert as NDEBUG says then, as C says.)
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <features.h>

#ifndef __ASSERT_DECLARED	/* (once: assert.h may come again inside a
				   function, after its statements) */
#define __ASSERT_DECLARED
extern void __assert __P ((__const char *, __const char *, int));
#endif

#undef assert
#ifdef NDEBUG
#define assert(e)	((void) 0)
#else
#define assert(e)	((e) ? (void) 0 : __assert(#e, __FILE__, __LINE__))
#endif
