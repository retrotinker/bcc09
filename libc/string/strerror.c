/* strerror(e): the message for an error number, as the GNU C library
 * words it (errno.h's numbers are Linux's), or "Unknown error n"
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <string.h>
#include <stdlib.h>
#include <errno.h>

static struct
{
   int e;
   char *s;
} msgs[] =
{
   { 0, "Success" },
   { ENOENT, "No such file or directory" },
   { EINTR, "Interrupted system call" },
   { EIO, "Input/output error" },
   { EBADF, "Bad file descriptor" },
   { ENOMEM, "Cannot allocate memory" },
   { EACCES, "Permission denied" },
   { EBUSY, "Device or resource busy" },
   { EEXIST, "File exists" },
   { ENODEV, "No such device" },
   { EINVAL, "Invalid argument" },
   { EMFILE, "Too many open files" },
   { ENOTTY, "Inappropriate ioctl for device" },
   { ENOSPC, "No space left on device" },
   { ESPIPE, "Illegal seek" },
   { EDOM, "Numerical argument out of domain" },
   { ERANGE, "Numerical result out of range" },
   { ENOTEMPTY, "Directory not empty" },
};

static char unknown[22] = "Unknown error ";

char *
strerror(e)
int e;
{
   int i;

   for (i = 0; i < sizeof(msgs) / sizeof(msgs[0]); i++)
      if (msgs[i].e == e)
	 return msgs[i].s;
   strcpy(unknown + 14, itoa(e));
   return unknown;
}
