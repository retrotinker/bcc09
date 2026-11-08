/* unistd.h - for bcc09's libc (so far, just the heap)
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#ifndef __UNISTD_H
#define __UNISTD_H
#include <features.h>
#include <sys/types.h>

/* move the end of the heap (see sbrk.s); the heap stays __heap_margin
   bytes below the stack pointer */
extern int brk __P ((void *));
extern void * sbrk __P ((int));
extern unsigned int __heap_margin;

#endif
