/* fcntl.h - for bcc09's libc
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).  The
 * flags have Linux's values, as in dev86.
 */

#ifndef __FCNTL_H
#define __FCNTL_H
#include <features.h>
#include <sys/types.h>

#define O_RDONLY	0
#define O_WRONLY	1
#define O_RDWR		2
#define O_ACCMODE	3
#define O_CREAT		0100
#define O_EXCL		0200
#define O_TRUNC		01000
#define O_APPEND	02000

/* each target's library has it (see libc/README) */
extern int open __P ((__const char *, int, ...));

#endif
