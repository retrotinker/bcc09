/* the sim6809 target's other system functions (bcc09 -Mi), for stdio:
 * each compiled separately (-DL_name).  The simulator has a standard
 * input and an output (which standard output and standard error share),
 * which act like a terminal; and no files.
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <errno.h>
#include <fcntl.h>
#include <unistd.h>

#ifdef L_isatty
int
isatty(fd)
int fd;
{
   if (fd >= 0 && fd <= 2)
      return 1;
   errno = (fd < 0) ? EBADF : ENOTTY;
   return 0;
}
#endif

#ifdef L_lseek
off_t
lseek(fd, offset, whence)
int fd;
off_t offset;
int whence;
{
   errno = (fd >= 0 && fd <= 2) ? ESPIPE : EBADF;
   return -1L;
}
#endif

#ifdef L_close
int
close(fd)
int fd;
{
   if (fd >= 0 && fd <= 2)
      return 0;
   errno = EBADF;
   return -1;
}
#endif

#ifdef L_open
int
open(const char *name, int flags, ...)
{
   errno = ENOENT;
   return -1;
}
#endif
