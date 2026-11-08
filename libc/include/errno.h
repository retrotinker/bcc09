/* errno.h - for bcc09's libc
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).  The
 * numbers are Linux's, as in dev86.
 */

#ifndef __ERRNO_H
#define __ERRNO_H

extern int errno;

#define ENOMEM	12		/* out of memory */
#define EINVAL	22		/* invalid argument */
#define EDOM	33		/* argument out of a math function's domain */
#define ERANGE	34		/* result out of range */

#endif
