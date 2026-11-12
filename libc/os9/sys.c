/* sys.c - the OS-9 target's system functions (bcc09 -Mo), for stdio, and
 * its directory functions (mkdir, chdir, opendir, readdir, rewinddir,
 * closedir): each compiled separately (-DL_name), on OS-9's system calls
 * (__os9call, call.s)
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
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <sys/stat.h>
#include <dirent.h>
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

   OS9_CLEAR(&r);
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

   OS9_CLEAR(&r);
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

   OS9_CLEAR(&r);
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

   OS9_CLEAR(&r);
   r.a = (flags & O_ACCMODE) + 1;	/* READ., WRITE., UPDAT. */
   r.x = (unsigned) name;
   __os9call(&r, OS9_OPEN);
   if (OS9_FAILED(&r) && r.b == E_PNNF && (flags & O_CREAT))
   {
      OS9_CLEAR(&r);
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

   OS9_CLEAR(&r);
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

   OS9_CLEAR(&r);
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

   OS9_CLEAR(&r);
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

   OS9_CLEAR(&r);
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

#ifdef L_mkdir
/* the mode's permissions as OS-9's attributes: the owner's read, write
   and execute are R, W and E, and the others' PR, PW and PE (the group's
   are left out) */
int
mkdir(name, mode)
const char *name;
mode_t mode;
{
   struct os9regs r;

   OS9_CLEAR(&r);
   r.b = (mode >> 6 & 7) | (mode << 3 & 0x38);
   r.x = (unsigned) name;
   __os9call(&r, OS9_MAKDIR);
   if (OS9_FAILED(&r))
   {
      errno = __os9errno(r.b);
      return -1;
   }
   return 0;
}
#endif

#ifdef L_chdir
/* the data directory (the execution directory stays) */
int
chdir(name)
const char *name;
{
   struct os9regs r;

   OS9_CLEAR(&r);
   r.a = 1;			/* READ. */
   r.x = (unsigned) name;
   __os9call(&r, OS9_CHGDIR);
   if (OS9_FAILED(&r))
   {
      errno = __os9errno(r.b);
      return -1;
   }
   return 0;
}
#endif

#if defined(L_rmdir) || defined(L_getcwd) || defined(L_rename)
/* open the directory name for reading, as a directory: its path number,
   or -1 with errno set */
static int
opendp(name)
const char *name;
{
   struct os9regs r;

   OS9_CLEAR(&r);
   r.a = 0x81;			/* DIR. + READ. */
   r.x = (unsigned) name;
   __os9call(&r, OS9_OPEN);
   if (OS9_FAILED(&r))
   {
      errno = __os9errno(r.b);
      return -1;
   }
   return r.a;
}

/* read the next 32-byte entry of directory path p into ent: 1, or 0 at
   the end (or an error) */
static int
nextent(p, ent)
int p;
unsigned char *ent;
{
   struct os9regs r;

   OS9_CLEAR(&r);
   r.a = p;
   r.x = (unsigned) ent;
   r.y = 32;
   __os9call(&r, OS9_READ);
   return !OS9_FAILED(&r) && r.y == 32;
}

static void
closep(p)
int p;
{
   struct os9regs r;

   OS9_CLEAR(&r);
   r.a = p;
   __os9call(&r, OS9_CLOSE);
}

/* an entry's LSN */
#define ENTLSN(e) ((long) (e)[29] << 16 | (unsigned) (e)[30] << 8 | (e)[31])
#endif

#ifdef L_rmdir
/* OS-9 has no call to remove a directory: as its deldir does, rmdir()
   checks that the directory is empty (every entry after ".." and "."
   deleted: with a first byte of 0), turns off its D attribute (I$SetStt
   SS.Attr, NitrOS-9's and Level 2's), and deletes it as a file; if the
   delete fails, the attribute goes back */
static int
setattr(name, mode, attr)
const char *name;
int mode;
int attr;
{
   struct os9regs r;
   int p;

   OS9_CLEAR(&r);
   r.a = mode;
   r.x = (unsigned) name;
   __os9call(&r, OS9_OPEN);
   if (OS9_FAILED(&r))
      return r.b;
   p = r.a;
   OS9_CLEAR(&r);
   r.a = p;
   r.b = SS_ATTR;
   r.x = attr;
   __os9call(&r, OS9_SETSTT);
   closep(p);
   return OS9_FAILED(&r) ? r.b : 0;
}

int
rmdir(name)
const char *name;
{
   struct os9regs r;
   unsigned char ent[32];
   int p, n, attr, err;

   if ((p = opendp(name)) < 0)
      return -1;
   for (n = 0; nextent(p, ent); n++)
      if (n >= 2 && ent[0] != 0)
      {
	 closep(p);
	 errno = ENOTEMPTY;
	 return -1;
      }
   OS9_CLEAR(&r);
   r.a = p;
   r.b = SS_FD;
   r.x = (unsigned) ent;
   r.y = 1;			/* (the attributes) */
   __os9call(&r, OS9_GETSTT);
   closep(p);
   if (OS9_FAILED(&r))
   {
      errno = __os9errno(r.b);
      return -1;
   }
   attr = ent[0];
   if ((err = setattr(name, 0x81, attr & 0x7f)) != 0)
   {
      errno = __os9errno(err);
      return -1;
   }
   OS9_CLEAR(&r);
   r.x = (unsigned) name;
   __os9call(&r, OS9_DELETE);
   if (OS9_FAILED(&r))
   {
      err = r.b;
      setattr(name, 0x01, attr);	/* (a file now: READ.) */
      errno = __os9errno(err);
      return -1;
   }
   return 0;
}
#endif

#ifdef L_getcwd
/* OS-9 has no call for it: as its pwd does, getcwd() goes up through
   "..", finding at each level the name of the entry whose LSN is the
   directory's own (its "." entry's), until a directory's ".." and "."
   are the same, the device's root; then the device's name (I$GetStt
   SS.DevNm) goes first: "/D1/USR/SRC".  The relative paths up ("..",
   "../.." ...) are at most 96 levels.  ERANGE if size is too small;
   with buf 0, a buffer of size bytes (or 256) from malloc */
#define MAXUP	96

char *
getcwd(buf, size)
char *buf;
size_t size;
{
   struct os9regs r;
   static char up[3 * MAXUP + 2];	/* ".", "..", "../.." ... */
   unsigned char ent[32];
   char *end;			/* the name so far is from end to buf + size */
   long self, parent;
   int p, n, i, len, levels, found;

   if (buf == 0)
   {
      if (size == 0)
	 size = 256;
      if ((buf = malloc(size)) == 0)
      {
	 errno = ENOMEM;
	 return 0;
      }
   }
   if (size < 2)
   {
      errno = size ? ERANGE : EINVAL;
      return 0;
   }
   end = buf + size - 1;
   *end = 0;
   strcpy(up, ".");
   for (levels = 0;; levels++)
   {
      /* this level's ".." and "." */
      if ((p = opendp(up)) < 0)
	 return 0;
      parent = self = -1;
      if (nextent(p, ent))
	 parent = ENTLSN(ent);
      if (nextent(p, ent))
	 self = ENTLSN(ent);
      if (self == parent || levels >= MAXUP)
	 break;			/* (the root: p stays open) */
      closep(p);
      /* its name, in the directory above */
      if (levels == 0)
	 strcpy(up, "..");
      else
	 strcat(up, "/..");
      if ((p = opendp(up)) < 0)
	 return 0;
      found = 0;
      for (n = 0; nextent(p, ent); n++)
	 if (n >= 2 && ent[0] != 0 && ENTLSN(ent) == self)
	 {
	    found = 1;
	    break;
	 }
      closep(p);
      if (!found)
      {
	 errno = ENOENT;
	 return 0;
      }
      for (len = 0; len < 29 && !(ent[len] & 0x80); len++)
	 ;
      len++;
      if (end - buf < len + 2)	/* (and the root's "/") */
      {
	 errno = ERANGE;
	 return 0;
      }
      end -= len;
      for (i = 0; i < len; i++)
	 end[i] = ent[i] & 0x7f;
      *--end = '/';
   }
   /* the device's name */
   OS9_CLEAR(&r);
   r.a = p;
   r.b = SS_DEVNM;
   r.x = (unsigned) ent;
   __os9call(&r, OS9_GETSTT);
   closep(p);
   if (OS9_FAILED(&r))
   {
      errno = __os9errno(r.b);
      return 0;
   }
   for (len = 0; len < 31 && !(ent[len] & 0x80); len++)
      ;
   len++;
   if (end - buf < len + 1)
   {
      errno = ERANGE;
      return 0;
   }
   end -= len;
   for (i = 0; i < len; i++)
      end[i] = ent[i] & 0x7f;
   *--end = '/';
   memmove(buf, end, buf + size - end);
   return buf;
}
#endif

#ifdef L_opendir
DIR *
opendir(name)
const char *name;
{
   struct os9regs r;
   DIR *d;

   OS9_CLEAR(&r);
   if ((d = malloc(sizeof(DIR))) == 0)
   {
      errno = ENOMEM;
      return 0;
   }
   r.a = 0x81;			/* DIR. + READ. */
   r.x = (unsigned) name;
   __os9call(&r, OS9_OPEN);
   if (OS9_FAILED(&r))
   {
      free(d);
      errno = __os9errno(r.b);
      return 0;
   }
   d->dd_fd = r.a;
   return d;
}
#endif

#ifdef L_readdir
/* the next entry of RBF's: 32 bytes, the name (with bit 7 set in its last
   character; none, a 0, for a deleted file) and its file descriptor's
   LSN; 0 at the end (errno as it was) */
struct dirent *
readdir(d)
DIR *d;
{
   struct os9regs r;
   unsigned char ent[32];
   int i;

   OS9_CLEAR(&r);
   do
   {
      r.a = d->dd_fd;
      r.x = (unsigned) ent;
      r.y = sizeof(ent);
      __os9call(&r, OS9_READ);	/* (I$ReadLn would stop at a 13) */
      if (OS9_FAILED(&r))
      {
	 if (r.b != E_EOF)
	    errno = __os9errno(r.b);
	 return 0;
      }
      if (r.y < sizeof(ent))
	 return 0;
   }
   while (ent[0] == 0);
   for (i = 0; i < 29; i++)
   {
      d->dd_ent.d_name[i] = ent[i] & 0x7f;
      if (ent[i] & 0x80)
      {
	 i++;
	 break;
      }
   }
   d->dd_ent.d_name[i] = 0;
   d->dd_ent.d_ino = (long) ent[29] << 16 | (unsigned) ent[30] << 8 | ent[31];
   return &d->dd_ent;
}
#endif

#ifdef L_rewinddir
void
rewinddir(d)
DIR *d;
{
   lseek(d->dd_fd, 0L, SEEK_SET);
}
#endif

#ifdef L_closedir
int
closedir(d)
DIR *d;
{
   int fd = d->dd_fd;

   free(d);
   return close(fd);
}
#endif

#ifdef L_rename
/* OS-9 has no call to rename a file: as its rename does, rename() finds
   the entry in the directory (opened for update, as a directory) and
   writes the new name over the old (up to 29 characters, the last with
   bit 7 set; RBF compares names without case).  new must be in the same
   directory as old (EINVAL if not), a name OS-9 takes (letters, digits,
   '.', '_' and '$'; EINVAL), and not there (EEXIST), as FLEX's rename()
   wants.  An open file goes on as it was. */

/* the last part of a path, and the length of what is before it */
static const char *
lastpart(path, dirlen)
const char *path;
int *dirlen;
{
   const char *p = strrchr(path, '/');

   *dirlen = p ? p - path : 0;
   return p ? p + 1 : path;
}

static int
okname(s)
const char *s;
{
   int n;

   for (n = 0; s[n]; n++)
      if (n >= 29 || !(isalnum((unsigned char) s[n]) || s[n] == '.' ||
		       s[n] == '_' || s[n] == '$'))
	 return 0;
   return n > 0;
}

/* entry name (bit 7 on its last character) is s, but for case */
static int
samename(ent, s)
unsigned char *ent;
const char *s;
{
   int i;

   for (i = 0; i < 29; i++)
   {
      if (s[i] == 0 || toupper(ent[i] & 0x7f) != toupper((unsigned char) s[i]))
	 return 0;
      if (ent[i] & 0x80)
	 return s[i + 1] == 0;
   }
   return 0;
}

int
rename(old, new)
const char *old, *new;
{
   struct os9regs r;
   unsigned char ent[32];
   static char dir[256], path[256 + 30];
   const char *oname, *nname;
   int olen, nlen, p, n, n2, i, err;

   oname = lastpart(old, &olen);
   nname = lastpart(new, &nlen);
   if (strchr(new, '/') && (nlen != olen || strncmp(old, new, olen) != 0)
       || !okname(nname) || olen >= sizeof(dir))
   {
      errno = EINVAL;		/* (not in the same directory, or a bad name) */
      return -1;
   }
   /* old's directory, and new's path in it */
   if (olen == 0)
      strcpy(dir, oname == old ? "." : "/");
   else
   {
      memcpy(dir, old, olen);
      dir[olen] = 0;
   }
   memcpy(path, old, oname - old);
   strcpy(path + (oname - old), nname);
   if (strcasecmp(oname, nname) != 0)	/* (another name: not there yet) */
   {
      OS9_CLEAR(&r);
      r.a = 0x01;		/* READ., a file */
      r.x = (unsigned) path;
      __os9call(&r, OS9_OPEN);
      if (OS9_FAILED(&r))
      {
	 OS9_CLEAR(&r);
	 r.a = 0x81;		/* DIR. + READ., a directory */
	 r.x = (unsigned) path;
	 __os9call(&r, OS9_OPEN);
      }
      if (!OS9_FAILED(&r))
      {
	 closep(r.a);
	 errno = EEXIST;
	 return -1;
      }
   }
   OS9_CLEAR(&r);
   r.a = 0x83;			/* DIR. + UPDAT. */
   r.x = (unsigned) dir;
   __os9call(&r, OS9_OPEN);
   if (OS9_FAILED(&r))
   {
      errno = __os9errno(r.b);
      return -1;
   }
   p = r.a;
   for (n = 0; nextent(p, ent); n++)
      if (n >= 2 && ent[0] != 0 && samename(ent, oname))
	 break;
   if (!(n >= 2 && ent[0] != 0 && samename(ent, oname)))
   {
      closep(p);
      errno = ENOENT;
      return -1;
   }
   n2 = strlen(nname);
   for (i = 0; i < 29; i++)
      ent[i] = i < n2 ? nname[i] : 0;
   ent[n2 - 1] |= 0x80;
   OS9_CLEAR(&r);		/* back to the entry */
   r.a = p;
   r.x = (unsigned) ((long) n * 32 >> 16);
   r.u = (unsigned) (n * 32);
   __os9call(&r, OS9_SEEK);
   if (!OS9_FAILED(&r))
   {
      OS9_CLEAR(&r);
      r.a = p;
      r.x = (unsigned) ent;
      r.y = 32;
      __os9call(&r, OS9_WRITE);
   }
   err = OS9_FAILED(&r) ? r.b : 0;
   closep(p);
   if (err)
   {
      errno = __os9errno(err);
      return -1;
   }
   return 0;
}
#endif
