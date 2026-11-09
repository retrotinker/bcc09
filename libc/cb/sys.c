/* the Color BASIC target's system functions (bcc09 -Me): I/O through the
 * ROM's POLCAT and CHROUT (see rom.s); each compiled separately
 * (-DL_name).  Standard input is the keyboard, read a line at a time as a
 * terminal would, and standard output and standard error are the screen.
 * The bytes pass as they are: a line ends with a carriage return (CR,
 * '\r'), on the screen and from the keyboard.  Descriptors from 3 up are
 * Disk BASIC's files (disk.c).
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include "cb.h"

#define KEY_BREAK	0x03
#define KEY_LEFT	0x08		/* the left arrow: rub out */
#define KEY_ENTER	0x0d
#define CR		0x0d


#ifdef L_write
ssize_t
write(fd, buf, n)
int fd;
const void *buf;
size_t n;
{
   register const char *p = buf;
   register size_t i;

   if (fd >= CB_FIRSTFILE && __cb_files)
      return (*__cb_files->write) (fd, buf, n);
   if (fd != 1 && fd != 2)
   {
      errno = EBADF;
      return -1;
   }
   for (i = 0; i < n; i++)
      __cb_chrout(p[i]);
   return n;
}
#endif

#ifdef L_read
/* A line from the keyboard, as a terminal gives it: the keys are shown as
   they are typed, the left arrow rubs out the last, and ENTER ends the
   line, which ends with a CR.  BREAK at the start of a line is the end
   of the input (read() gives 0).  A line longer than n comes in pieces. */
#define LINEMAX 128

static char line[LINEMAX];
static int have, next;		/* bytes in line, and the next to give */

ssize_t
read(fd, buf, n)
int fd;
void *buf;
size_t n;
{
   register char *p = buf;
   register int c;
   size_t got;

   if (fd >= CB_FIRSTFILE && __cb_files)
      return (*__cb_files->read) (fd, buf, n);
   if (fd != 0)
   {
      errno = EBADF;
      return -1;
   }
   if (next >= have)		/* get a line */
   {
      have = next = 0;
      for (;;)
      {
	 while ((c = __cb_polcat()) == 0)
	    ;
	 if (c == KEY_BREAK)
	 {
	    if (have == 0)
	       return 0;	/* the end of the input */
	    continue;
	 }
	 if (c == KEY_LEFT)
	 {
	    if (have > 0)
	    {
	       have--;
	       __cb_chrout(KEY_LEFT);
	    }
	    continue;
	 }
	 if (c == KEY_ENTER)
	 {
	    __cb_chrout(CR);
	    line[have++] = CR;
	    break;
	 }
	 if (have < LINEMAX - 1)	/* (keep room for the CR) */
	 {
	    line[have++] = c;
	    __cb_chrout(c);
	 }
      }
   }
   for (got = 0; got < n && next < have; got++)
      *p++ = line[next++];
   return got;
}
#endif

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
   if (fd >= CB_FIRSTFILE && __cb_files)
      return (*__cb_files->lseek) (fd, offset, whence);
   errno = (fd >= 0 && fd <= 2) ? ESPIPE : EBADF;
   return -1L;
}
#endif

#ifdef L_close
int
close(fd)
int fd;
{
   if (fd >= CB_FIRSTFILE && __cb_files)
      return (*__cb_files->close) (fd);
   if (fd >= 0 && fd <= 2)
      return 0;
   errno = EBADF;
   return -1;
}
#endif

#ifdef L___cb_files
struct __cb_fileops *__cb_files;	/* (disk.c's open() sets it) */
#endif
