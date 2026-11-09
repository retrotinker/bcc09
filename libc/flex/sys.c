/* sys.c - the FLEX target's system functions (bcc09 -Mf): I/O through
 * FLEX's INCH and PUTCHR (see flex.s); each compiled separately
 * (-DL_name).  Standard input is the terminal, read a line at a time as a
 * terminal would, and standard output and standard error go to the
 * terminal.  The bytes pass as they are: a line typed ends with a CR
 * ('\r'), and FLEX's terminal starts a new line with CR LF ("\r\n").
 * There are no files yet.
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <errno.h>
#include <fcntl.h>
#include <unistd.h>

#define CR		0x0d
#define LF		0x0a
#define BSCH		(*(unsigned char *) 0xcc00)	/* TTYSET's backspace */

extern int __flex_inch();
extern void __flex_putchr();

#ifdef L_write
ssize_t
write(fd, buf, n)
int fd;
const void *buf;
size_t n;
{
   register const char *p = buf;
   register size_t i;

   if (fd != 1 && fd != 2)
   {
      errno = EBADF;
      return -1;
   }
   for (i = 0; i < n; i++)
      __flex_putchr(p[i]);
   return n;
}
#endif

#ifdef L_read
/* A line from the terminal, as a terminal gives it: the characters are
   shown as they are typed, the backspace character (TTYSET's, or ^H)
   rubs out the last, and CR ends the line (shown as CR LF), which ends
   with the CR.  A NUL at the start of a line is the end of the input
   (read() gives 0; sim6809 --flex gives NULs after its input).  A line
   longer than n comes in pieces. */
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
   int bs = BSCH ? BSCH : 0x08;

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
	 c = __flex_inch() & 0x7f;
	 if (c == 0)
	 {
	    if (have == 0)
	       return 0;	/* the end of the input */
	    break;
	 }
	 if (c == bs)
	 {
	    if (have > 0)
	    {
	       have--;
	       __flex_putchr(bs);
	       __flex_putchr(' ');
	       __flex_putchr(bs);
	    }
	    continue;
	 }
	 if (c == CR)
	 {
	    __flex_putchr(CR);
	    __flex_putchr(LF);
	    line[have++] = CR;
	    break;
	 }
	 if (have < LINEMAX - 1)	/* (keep room for the CR) */
	 {
	    line[have++] = c;
	    __flex_putchr(c);
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
   errno = ENOENT;		/* (no files yet) */
   return -1;
}
#endif
