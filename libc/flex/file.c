/* file.c - FLEX's files for the FLEX target (bcc09 -Mf): open(),
 * unlink() and rename(), and the read(), write(), lseek() and close() of
 * the files open() opens (through __flex_files, flex.h), on FLEX's File
 * Management System (FMS, through __flex_fms, flex.s), with a File
 * Control Block from malloc for each
 *
 * A name is [D.]NAME[.EXT] or NAME[.EXT][.D], as FLEX writes them: NAME
 * of 1 to 8 letters, digits, - and _, starting with a letter, EXT of up
 * to 3, D the drive (FLEX's working drive if there is none); it is made
 * upper case, as FLEX's commands make it.
 *
 * FLEX writes a file only from its start: O_WRONLY makes a new one, and
 * if the file is there, it must be O_TRUNC, which deletes it first
 * (fopen()'s "w" is); O_RDWR and O_APPEND aren't possible (EINVAL).  A
 * file is text, whose runs of spaces FMS stores compressed, unless it is
 * opened with O_BINARY (fopen()'s "b").  FMS skips NULs in a text file,
 * but a binary file's last sector is padded with zeros, which read()
 * gives: FLEX keeps a file's size only in sectors.  lseek() works on a
 * file open for reading (it rewinds, and reads up to the place, which
 * can't be past the end); on one open for writing, it can only say where
 * it is.  FMS's errors become errno's EBUSY, EEXIST, ENOENT, ENOSPC,
 * EACCES and ENODEV, or EIO.
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <errno.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "flex.h"

#define NFILES		4
#define FCBSIZE		320
#define WRKDRV		(*(unsigned char *) 0xcc0c)

/* FCB offsets */
#define FUNC		0
#define ERR		1
#define DRIVE		3
#define NAME		4
#define NEWNAME		53
#define COMP		59

/* FMS functions and errors */
#define F_BYTE		0
#define F_OPENR		1
#define F_OPENW		2
#define F_CLOSE		4
#define F_REWIND	5
#define F_DELETE	12
#define F_RENAME	13
#define E_EOF		8

struct ffile
{
   unsigned char *fcb;		/* 0 if not open */
   int write;
   int binary;			/* (FMS's rewind makes the FCB text) */
   long pos;
};

static struct ffile files[NFILES];

static int fread1(), fwrite1(), fclose1();
static long flseek1();
static struct __flex_fileops ops = { fread1, fwrite1, flseek1, fclose1 };

static int
errnoof(e)
int e;
{
   switch (e)
   {
   case 2:
      return EBUSY;
   case 3:
      return EEXIST;
   case 4:
   case 21:
      return ENOENT;
   case 7:
      return ENOSPC;
   case 11:
   case 12:
   case 17:
      return EACCES;
   case 16:
      return ENODEV;
   }
   return EIO;
}

/* FMS function f on fcb, with a; its A, or -1 (errno set) */
static int
call(fcb, f, a)
unsigned char *fcb;
int f, a;
{
   int r;

   fcb[FUNC] = f;
   if ((r = __flex_fms(fcb, a)) < 0)
   {
      errno = errnoof(-r);
      return -1;
   }
   return r;
}

#define ALPHA(c)	((c) >= 'A' && (c) <= 'Z')
#define NAMECH(c)	(ALPHA(c) || ((c) >= '0' && (c) <= '9') || \
			 (c) == '-' || (c) == '_')

/* name into the FCB's name, extension and drive (at off: NAME, or
   NEWNAME without the drive); 0, or -1 */
static int
parse(name, fcb, off)
char *name;
unsigned char *fcb;
int off;
{
   char part[3][9];
   int n = 0, len = 0, c, i, first = 0;

   memset(fcb + off, 0, 11);
   for (;; name++)
   {
      c = *name;
      if (c >= 'a' && c <= 'z')
	 c -= 'a' - 'A';
      if (c == '.' || c == 0)
      {
	 if (n == 3 || len == 0)
	    return -1;
	 part[n++][len] = 0;
	 len = 0;
	 if (c == 0)
	    break;
	 continue;
      }
      if (n == 3 || !NAMECH(c) || len == 8)
	 return -1;
      part[n][len++] = c;
   }
   if (off == NAME)
      fcb[DRIVE] = WRKDRV;
   /* a drive: a single digit, first or last */
   if (n > 1 && part[0][1] == 0 && part[0][0] >= '0' && part[0][0] <= '3')
   {
      if (off == NAME)
	 fcb[DRIVE] = part[0][0] - '0';
      first = 1;
   }
   else if (n > 1 && part[n - 1][1] == 0 && part[n - 1][0] >= '0' &&
	    part[n - 1][0] <= '3')
   {
      if (off == NAME)
	 fcb[DRIVE] = part[n - 1][0] - '0';
      n--;
   }
   n -= first;
   if (n < 1 || n > 2 || !ALPHA(part[first][0]) || strlen(part[first + n - 1]) > (n == 2 ? 3 : 8))
      return -1;
   for (i = 0; part[first][i]; i++)
      fcb[off + i] = part[first][i];
   if (n == 2)
      for (i = 0; part[first + 1][i]; i++)
	 fcb[off + 8 + i] = part[first + 1][i];
   return 0;
}

/* a new FCB for name, or 0 */
static unsigned char *
newfcb(name)
char *name;
{
   unsigned char *fcb;

   if ((fcb = malloc(FCBSIZE)) == 0)
   {
      errno = ENOMEM;
      return 0;
   }
   memset(fcb, 0, FCBSIZE);
   if (parse(name, fcb, NAME) < 0)
   {
      free(fcb);
      errno = ENOENT;
      return 0;
   }
   return fcb;
}

int
open(const char *name, int flags, ...)
{
   unsigned char *fcb;
   int fd, write = (flags & O_ACCMODE) == O_WRONLY;

   if ((flags & O_ACCMODE) == O_RDWR || (flags & O_APPEND))
   {
      errno = EINVAL;
      return -1;
   }
   for (fd = 0; fd < NFILES && files[fd].fcb; fd++)
      ;
   if (fd == NFILES)
   {
      errno = EMFILE;
      return -1;
   }
   if ((fcb = newfcb(name)) == 0)
      return -1;
   if (write)
   {
      /* (FLEX makes only new files: an old one goes first, if O_TRUNC
	 says it may) */
      if (call(fcb, F_OPENW, 0) < 0)
      {
	 if (errno != EEXIST || (flags & O_EXCL))
	    goto fail;
	 if (!(flags & O_TRUNC))
	 {
	    errno = EINVAL;
	    goto fail;
	 }
	 /* (delete marks the FCB's name deleted, as the directory's
	    entry: the FCB starts again, as a new one) */
	 if (call(fcb, F_DELETE, 0) < 0)
	    goto fail;
	 memset(fcb, 0, FCBSIZE);
	 if (parse(name, fcb, NAME) < 0 || call(fcb, F_OPENW, 0) < 0)
	    goto fail;
      }
      else if (!(flags & O_CREAT))
      {
	 call(fcb, F_CLOSE, 0);	/* (empty: FLEX removes it) */
	 errno = ENOENT;
	 goto fail;
      }
   }
   else if (call(fcb, F_OPENR, 0) < 0)
      goto fail;
   if (flags & O_BINARY)
      fcb[COMP] = 0xff;
   files[fd].fcb = fcb;
   files[fd].write = write;
   files[fd].binary = (flags & O_BINARY) != 0;
   files[fd].pos = 0;
   __flex_files = &ops;
   return fd + FLEX_FIRSTFILE;
fail:
   free(fcb);
   return -1;
}

static struct ffile *
fileof(fd)
int fd;
{
   fd -= FLEX_FIRSTFILE;
   if (fd < 0 || fd >= NFILES || files[fd].fcb == 0)
   {
      errno = EBADF;
      return 0;
   }
   return &files[fd];
}

static int
fread1(fd, buf, n)
int fd;
char *buf;
int n;
{
   struct ffile *f;
   int done = 0, c;

   if ((f = fileof(fd)) == 0)
      return -1;
   if (f->write)
   {
      errno = EBADF;
      return -1;
   }
   while (done < n)
   {
      if ((c = __flex_fms(f->fcb, 0)) < 0)
      {
	 if (c == -E_EOF)
	    break;
	 errno = errnoof(-c);
	 return done ? done : -1;
      }
      buf[done++] = c;
      f->pos++;
   }
   return done;
}

static int
fwrite1(fd, buf, n)
int fd;
char *buf;
int n;
{
   struct ffile *f;
   int done, c;

   if ((f = fileof(fd)) == 0)
      return -1;
   if (!f->write)
   {
      errno = EBADF;
      return -1;
   }
   for (done = 0; done < n; done++)
   {
      if ((c = __flex_fms(f->fcb, buf[done])) < 0)
      {
	 errno = errnoof(-c);
	 return done ? done : -1;
      }
      f->pos++;
   }
   return done;
}

static long
flseek1(fd, offset, whence)
int fd;
long offset;
int whence;
{
   struct ffile *f;
   char c;

   if ((f = fileof(fd)) == 0)
      return -1L;
   if (whence == SEEK_CUR)
      offset += f->pos;
   else if (whence == SEEK_END)
   {
      /* (the size: read to the end) */
      if (f->write)
	 offset += f->pos;
      else
      {
	 while (fread1(fd, &c, 1) == 1)
	    ;
	 offset += f->pos;
      }
   }
   else if (whence != SEEK_SET)
      offset = -1;
   if (offset < 0)
   {
      errno = EINVAL;
      return -1L;
   }
   if (f->write)
   {
      if (offset != f->pos)
      {
	 errno = ESPIPE;
	 return -1L;
      }
      return offset;
   }
   if (offset < f->pos)
   {
      if (call(f->fcb, F_REWIND, 0) < 0)
	 return -1L;
      if (f->binary)
	 f->fcb[COMP] = 0xff;	/* (rewind makes it text again) */
      f->pos = 0;
   }
   while (f->pos < offset)
      if (fread1(fd, &c, 1) != 1)
      {
	 errno = EINVAL;	/* (past the end) */
	 return -1L;
      }
   return offset;
}

static int
fclose1(fd)
int fd;
{
   struct ffile *f;
   int r;

   if ((f = fileof(fd)) == 0)
      return -1;
   r = call(f->fcb, F_CLOSE, 0) < 0 ? -1 : 0;
   free(f->fcb);
   f->fcb = 0;
   return r;
}

/* (not while it is open: EBUSY) */
int
unlink(name)
const char *name;
{
   unsigned char *fcb;
   int r;

   if ((fcb = newfcb(name)) == 0)
      return -1;
   r = call(fcb, F_DELETE, 0) < 0 ? -1 : 0;
   free(fcb);
   return r;
}

/* (not to another drive: the new name's drive is ignored) */
int
rename(old, new)
const char *old, *new;
{
   unsigned char *fcb;
   int r = -1;

   if ((fcb = newfcb(old)) == 0)
      return -1;
   if (parse(new, fcb, NEWNAME) < 0)
      errno = ENOENT;
   else
      r = call(fcb, F_RENAME, 0) < 0 ? -1 : 0;
   free(fcb);
   return r;
}
