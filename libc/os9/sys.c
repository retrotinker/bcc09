/* sys.c - the OS-9 target's system functions (bcc09 -Mo), for stdio:
 * each compiled separately (-DL_name), on OS-9's system calls
 * (__os9call, sys.s)
 *
 * read() and write() pass bytes as they are (no translation of OS-9's CR
 * line ends).  They use I$ReadLn and I$WritLn, which a terminal (SCF)
 * edits and echoes a line at a time, as a Unix terminal is read and
 * written; so read() gives at most a line (up to a CR), from a file too.
 * errno is ENOENT, EBADF, EACCES, EEXIST or ENOMEM for OS-9's errors
 * that are those, EIO for the rest.
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include "os9.h"

#ifdef L___os9errno
int
__os9errno(b)
int b;
{
   switch (b)
   {
   case E_PNNF:
      return ENOENT;
   case E_BPNUM:
      return EBADF;
   case E_FNA:
   case E_BMODE:
      return EACCES;
   case E_CEF:
      return EEXIST;
   case E_MEMFUL:
      return ENOMEM;
   }
   return EIO;
}
#endif

#ifdef L__exit
void
_exit(status)
int status;
{
   struct os9regs r;

   r.b = status;
   __os9call(&r, OS9_EXIT);
}
#endif

#ifdef L_write
/* (I$WritLn writes up to a CR, so it may take more than one) */
int
write(fd, buf, n)
int fd;
char *buf;
int n;
{
   struct os9regs r;
   int done;

   for (done = 0; done < n; done += r.y)
   {
      r.a = fd;
      r.x = (unsigned) (buf + done);
      r.y = n - done;
      __os9call(&r, OS9_WRITLN);
      if (OS9_FAILED(&r))
      {
	 errno = __os9errno(r.b);
	 return done ? done : -1;
      }
      if (r.y == 0)
	 break;
   }
   return done;
}
#endif

#ifdef L_read
/* up to a line (a CR); 0 at the end of the file */
int
read(fd, buf, n)
int fd;
char *buf;
int n;
{
   struct os9regs r;

   r.a = fd;
   r.x = (unsigned) buf;
   r.y = n;
   __os9call(&r, OS9_READLN);
   if (OS9_FAILED(&r))
   {
      if (r.b == E_EOF)
	 return 0;
      errno = __os9errno(r.b);
      return -1;
   }
   return r.y;
}
#endif

#ifdef L_open
/* O_CREAT makes the file if there is none (I$Create, read and write for
   its owner, read for others); O_TRUNC empties it; O_APPEND starts at its
   end (each write doesn't go there again) */
int
open(const char *name, int flags, ...)
{
   struct os9regs r;
   int fd;

   r.a = (flags & O_ACCMODE) + 1;	/* READ., WRITE., UPDAT. */
   r.x = (unsigned) name;
   __os9call(&r, OS9_OPEN);
   if (OS9_FAILED(&r) && r.b == E_PNNF && (flags & O_CREAT))
   {
      r.a = (flags & O_ACCMODE) + 1;
      r.b = 0x0b;		/* PR, W, R */
      r.x = (unsigned) name;
      __os9call(&r, OS9_CREATE);
   }
   else if (!OS9_FAILED(&r) && (flags & (O_CREAT | O_EXCL)) ==
	    (O_CREAT | O_EXCL))
   {
      fd = r.a;
      r.a = fd;
      __os9call(&r, OS9_CLOSE);
      errno = EEXIST;
      return -1;
   }
   if (OS9_FAILED(&r))
   {
      errno = __os9errno(r.b);
      return -1;
   }
   fd = r.a;
   if (flags & O_TRUNC)
   {
      r.a = fd;
      r.b = SS_SIZE;
      r.x = r.u = 0;
      __os9call(&r, OS9_SETSTT);
   }
   if (flags & O_APPEND)
      lseek(fd, 0L, SEEK_END);
   return fd;
}
#endif

#ifdef L_close
int
close(fd)
int fd;
{
   struct os9regs r;

   r.a = fd;
   __os9call(&r, OS9_CLOSE);
   if (OS9_FAILED(&r))
   {
      errno = __os9errno(r.b);
      return -1;
   }
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
   struct os9regs r;
   off_t base = 0;

   if (whence != SEEK_SET)
   {
      r.a = fd;
      r.b = whence == SEEK_CUR ? SS_POS : SS_SIZE;
      __os9call(&r, OS9_GETSTT);
      if (OS9_FAILED(&r))
      {
	 errno = r.b == E_BPNUM ? EBADF : ESPIPE;
	 return -1L;
      }
      base = (long) r.x << 16 | r.u;
   }
   offset += base;
   if (offset < 0)
   {
      errno = EINVAL;
      return -1L;
   }
   r.a = fd;
   r.x = offset >> 16;
   r.u = offset;
   __os9call(&r, OS9_SEEK);
   if (OS9_FAILED(&r))
   {
      errno = r.b == E_BPNUM ? EBADF : ESPIPE;
      return -1L;
   }
   return offset;
}
#endif

#ifdef L_isatty
/* a terminal is an SCF device (the first of its path options is 0) */
int
isatty(fd)
int fd;
{
   struct os9regs r;
   char opts[32];

   r.a = fd;
   r.b = SS_OPT;
   r.x = (unsigned) opts;
   __os9call(&r, OS9_GETSTT);
   if (OS9_FAILED(&r))
   {
      errno = __os9errno(r.b);
      return 0;
   }
   if (opts[0] != 0)
   {
      errno = ENOTTY;
      return 0;
   }
   return 1;
}
#endif

#ifdef L_unlink
int
unlink(name)
const char *name;
{
   struct os9regs r;

   r.x = (unsigned) name;
   __os9call(&r, OS9_DELETE);
   if (OS9_FAILED(&r))
   {
      errno = __os9errno(r.b);
      return -1;
   }
   return 0;
}
#endif
