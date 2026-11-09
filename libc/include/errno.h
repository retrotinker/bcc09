/* errno.h - for bcc09's libc
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).  The
 * numbers are Linux's, as in dev86.
 */

#ifndef __ERRNO_H
#define __ERRNO_H

extern int errno;

#define ENOENT	2		/* no such file or directory */
#define EINTR	4		/* interrupted system call */
#define EIO	5		/* input or output failed */
#define EBADF	9		/* bad file descriptor */
#define ENOMEM	12		/* out of memory */
#define EACCES	13		/* permission denied */
#define EEXIST	17		/* file exists */
#define EINVAL	22		/* invalid argument */
#define ENOTTY	25		/* not a terminal */
#define ESPIPE	29		/* can't seek */
#define EDOM	33		/* argument out of a math function's domain */
#define ERANGE	34		/* result out of range */

#endif
