/* unistd.h - for bcc09's libc
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#ifndef __UNISTD_H
#define __UNISTD_H
#include <features.h>
#include <sys/types.h>

#define STDIN_FILENO	0
#define STDOUT_FILENO	1
#define STDERR_FILENO	2

#ifndef SEEK_SET
#define SEEK_SET	0
#define SEEK_CUR	1
#define SEEK_END	2
#endif

/* each target's library has these (see libc/README) */
extern ssize_t read __P ((int, void *, size_t));
extern ssize_t write __P ((int, __const void *, size_t));
extern int close __P ((int));
extern off_t lseek __P ((int, off_t, int));
extern int isatty __P ((int));
extern int unlink __P ((__const char *));
extern int chdir __P ((__const char *));	/* (OS-9's) */
extern int rmdir __P ((__const char *));	/* (OS-9's) */
extern char *getcwd __P ((char *, size_t));	/* (OS-9's) */

/* move the end of the heap (see sbrk.s); the heap stays __heap_margin
   bytes below the stack pointer (but on OS-9, where it is above it) */
extern int brk __P ((void *));
extern void * sbrk __P ((int));
extern unsigned int __heap_margin;

#endif
