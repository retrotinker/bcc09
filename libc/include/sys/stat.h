/* sys/stat.h - for bcc09's libc: mkdir (OS-9's)
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#ifndef __SYS_STAT_H
#define __SYS_STAT_H
#include <features.h>
#include <sys/types.h>

#define S_IRWXU	0700
#define S_IRUSR	0400
#define S_IWUSR	0200
#define S_IXUSR	0100
#define S_IRWXG	0070
#define S_IRWXO	0007

/* (the mode is a Unix one; OS-9 gives a directory every permission) */
extern int mkdir __P ((__const char *, mode_t));

#endif
