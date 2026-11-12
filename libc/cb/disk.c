/* disk.c - Disk BASIC's files for the Color BASIC target (bcc09 -Me):
 * open(), unlink() and rename(), and the read(), write(), lseek() and close() of
 * the files open() opens (through __cb_files, cb.h), on the sectors that
 * Disk BASIC's DSKCON reads and writes (rom.s)
 *
 * The disks are RS-DOS's: 35 tracks of 18 sectors of 256 bytes; track 17
 * holds the FAT (sector 2) and the directory (sectors 3 to 11, 8 entries
 * of 32 bytes in each); the rest is 68 granules of 9 sectors (half a
 * track).  The FAT's byte for a granule is $FF if it is free, the next
 * granule of its file, or $C0 + the number of sectors used if it is the
 * last.  A directory entry has the name (8 bytes, padded with blanks),
 * the extension (3), the type (1: data), the ASCII flag ($FF), the first
 * granule and the number of bytes used in the last sector (2); its first
 * byte is 0 if the entry was deleted, $FF if it and the rest were never
 * used.
 *
 * A name is NAME.EXT (or NAME/EXT), with :D after it for drive D (0 to
 * 3; Disk BASIC's default drive, DEFDRV, if there is none, or 0 if that
 * isn't one); its case is
 * kept.  A new file is a data file (type 1) marked ASCII, as Disk BASIC's
 * OPEN "O" makes them; new granules are picked as Disk BASIC picks them.  The FAT is written when a file is
 * made, closed or deleted, and a file's directory entry when it is made
 * and closed.  lseek() can't go past the end of a file.  The FAT is read
 * again when a file is opened on a drive with none open, so a disk
 * changed meanwhile is seen.
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <errno.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include "cb.h"

#define NFILES		4	/* files open at a time */
#define NDRIVES		4
#define SECSIZE		256
#define GRANSECS	9
#define GRANSIZE	((long) GRANSECS * SECSIZE)
#define NGRANS		68
#define DIRTRACK	17
#define FATSEC		2
#define DIRSEC		3	/* to DIRSEC + 8 */
#define DIRSECS		9
#define FREE		0xff
#define LAST		0xc0	/* + the sectors used */
#define READ		2	/* DSKCON's operations */
#define WRITE		3
#define DEFDRV		(*(unsigned char *) 0x095a)

struct dfile
{
   char open;
   char dirty;			/* buf to be written */
   char changed;		/* the size: the FAT and entry to write */
   unsigned char drive;
   unsigned char dirsec;	/* where its directory entry is */
   unsigned char dirent;
   unsigned char first;		/* its first granule */
   int flags;			/* open()'s */
   int bufsec;			/* the file's sector in buf, or -1 */
   long size;
   long pos;
   unsigned char buf[SECSIZE];
};

static struct dfile files[NFILES];
static unsigned char fat[NDRIVES][NGRANS];
static char fatok[NDRIVES];
static unsigned char sec[SECSIZE];	/* the FAT's and directory's */

static int dread(), dwrite(), dclose();
static long dlseek();
static struct __cb_fileops ops = { dread, dwrite, dlseek, dclose };

/* sector s (1 to 18) of track t on drive d to or from buf; 0, or -1 */
static int
disk(op, d, t, s, buf)
int op, d, t, s;
unsigned char *buf;
{
   if (__cb_dskcon(op, d, t, s, buf) != 0)
   {
      errno = EIO;
      return -1;
   }
   return 0;
}

static int
loadfat(d)
int d;
{
   if (disk(READ, d, DIRTRACK, FATSEC, sec) < 0)
      return -1;
   memcpy(fat[d], sec, NGRANS);
   fatok[d] = 1;
   return 0;
}

static int
savefat(d)
int d;
{
   if (disk(READ, d, DIRTRACK, FATSEC, sec) < 0)
      return -1;
   memcpy(sec, fat[d], NGRANS);
   return disk(WRITE, d, DIRTRACK, FATSEC, sec);
}

/* the track and first sector of granule g */
#define GTRACK(g)	((g) / 2 < DIRTRACK ? (g) / 2 : (g) / 2 + 1)
#define GSECTOR(g)	(((g) & 1) * GRANSECS + 1)

/* a free granule (marked the last of a file, with no sectors used), or
   -1: as Disk BASIC picks them, a track at a time outward from the
   directory's, the one before it first (16, 18, 15, 19...), and the
   track's first granule first */
static int
newgran(d)
int d;
{
   int i, t, g;

   for (i = 0; i < 2 * (NGRANS / 2); i++)
   {
      t = i / 2 & 1 ? DIRTRACK + 1 + i / 4 : DIRTRACK - 1 - i / 4;
      if (t < 0 || t > NGRANS / 2)
	 continue;
      g = (t < DIRTRACK ? t : t - 1) * 2 + (i & 1);
      if (fat[d][g] == FREE)
      {
	 fat[d][g] = LAST;
	 return g;
      }
   }
   errno = ENOSPC;
   return -1;
}

/* free the granules from g on */
static void
freegrans(d, g)
int d, g;
{
   int next, n;

   for (n = 0; g < NGRANS && n < NGRANS; n++)
   {
      next = fat[d][g];
      fat[d][g] = FREE;
      g = next;
   }
}

/* the granule of f's sector n, making the file that long if make; -1 if
   it isn't (errno ENOSPC if it can't be made) */
static int
granof(f, n, make)
struct dfile *f;
int n, make;
{
   unsigned char *ft = fat[f->drive];
   int g = f->first, k, next;

   for (k = n / GRANSECS; k > 0; k--)
   {
      next = ft[g];
      if (next >= NGRANS)
      {
	 if (!make)
	    return -1;
	 if ((next = newgran(f->drive)) < 0)
	    return -1;
	 ft[g] = next;
	 f->changed = 1;
      }
      g = next;
   }
   return g;
}

/* write f's buffer to its sector */
static int
flush(f)
struct dfile *f;
{
   int g;

   if (!f->dirty)
      return 0;
   if ((g = granof(f, f->bufsec, 1)) < 0)
      return -1;
   if (disk(WRITE, f->drive, GTRACK(g), GSECTOR(g) + f->bufsec % GRANSECS,
	    f->buf) < 0)
      return -1;
   f->dirty = 0;
   return 0;
}

/* f's sector n into its buffer (0s past the end of the file) */
static int
load(f, n)
struct dfile *f;
int n;
{
   long start = (long) n * SECSIZE;
   int g, used;

   if (f->bufsec == n)
      return 0;
   if (flush(f) < 0)
      return -1;
   f->bufsec = -1;
   used = 0;
   if (start < f->size)
   {
      if ((g = granof(f, n, 0)) < 0)
      {
	 errno = EIO;
	 return -1;
      }
      if (disk(READ, f->drive, GTRACK(g), GSECTOR(g) + n % GRANSECS,
	       f->buf) < 0)
	 return -1;
      used = f->size - start < SECSIZE ? (int) (f->size - start) : SECSIZE;
   }
   memset(f->buf + used, 0, SECSIZE - used);
   f->bufsec = n;
   return 0;
}

/* the size of the file whose first granule is g and last sector holds
   last bytes, from the FAT; -1 if the chain is broken */
static long
fsize(d, g, last)
int d, g, last;
{
   long size = 0;
   int n, c;

   for (n = 0; n < NGRANS; n++)
   {
      if (g >= NGRANS)
	 return -1;
      c = fat[d][g];
      if (c >= LAST && c <= LAST + GRANSECS)
      {
	 c -= LAST;
	 return c == 0 ? size : size + (long) (c - 1) * SECSIZE + last;
      }
      size += GRANSIZE;
      g = c;
   }
   return -1;
}

/* name as an entry's 11 bytes in ent, and its drive; 0, or -1 */
static int
parse(name, ent, drive)
char *name;
unsigned char *ent;
int *drive;
{
   int i, n;

   memset(ent, ' ', 11);
   *drive = DEFDRV < NDRIVES ? DEFDRV : 0;
   for (i = 0, n = 0; name[i] && name[i] != '.' && name[i] != '/' &&
	name[i] != ':'; i++)
      if (n < 8)
	 ent[n++] = name[i];
      else
	 return -1;
   if (n == 0)
      return -1;
   if (name[i] == '.' || name[i] == '/')
      for (i++, n = 8; name[i] && name[i] != ':'; i++)
	 if (n < 11)
	    ent[n++] = name[i];
	 else
	    return -1;
   if (name[i] == ':')
   {
      if (name[i + 1] < '0' || name[i + 1] >= '0' + NDRIVES ||
	  name[i + 2] != 0)
	 return -1;
      *drive = name[i + 1] - '0';
   }
   return 0;
}

/* the entry for name (11 bytes) on drive d: its sector and number, and
   (in sec) the sector; 1 if found, 0 if not (then a free entry's place,
   or 0 sector if none), -1 for an error */
static int
lookup(d, name, dsec, dent)
int d;
unsigned char *name;
int *dsec, *dent;
{
   int s, e, fs = 0, fe = 0, end = 0;
   unsigned char *p;

   for (s = DIRSEC; s < DIRSEC + DIRSECS && !end; s++)
   {
      if (disk(READ, d, DIRTRACK, s, sec) < 0)
	 return -1;
      for (e = 0; e < SECSIZE / 32; e++)
      {
	 p = sec + e * 32;
	 if (*p == 0xff)
	    end = 1;
	 if (*p == 0xff || *p == 0)
	 {
	    if (fs == 0)
	    {
	       fs = s;
	       fe = e;
	    }
	    if (end)
	       break;
	    continue;
	 }
	 if (memcmp(p, name, 11) == 0)
	 {
	    *dsec = s;
	    *dent = e;
	    return 1;
	 }
      }
   }
   *dsec = fs;
   *dent = fe;
   return 0;
}

static int
opendrive(d)
int d;
{
   int i;

   for (i = 0; i < NFILES; i++)
      if (files[i].open && files[i].drive == d)
	 return 0;
   return loadfat(d);	/* (none open: read it again) */
}

/* O_CREAT makes the file if it isn't there (O_EXCL: fails if it is);
   O_TRUNC empties it; O_APPEND writes at its end */
int
open(const char *name, int flags, ...)
{
   unsigned char ent[11];
   struct dfile *f;
   int d, fd, dsec, dent, found, g;
   unsigned char *p;

   if (!__cb_hasdisk())
   {
      errno = ENODEV;
      return -1;
   }
   if (parse(name, ent, &d) < 0)
   {
      errno = ENOENT;
      return -1;
   }
   for (fd = 0; fd < NFILES && files[fd].open; fd++)
      ;
   if (fd == NFILES)
   {
      errno = EMFILE;
      return -1;
   }
   f = &files[fd];
   if (opendrive(d) < 0 || (found = lookup(d, ent, &dsec, &dent)) < 0)
      return -1;
   if (found && (flags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
   {
      errno = EEXIST;
      return -1;
   }
   if (!found && !(flags & O_CREAT))
   {
      errno = ENOENT;
      return -1;
   }
   if (!found && dsec == 0)
   {
      errno = ENOSPC;		/* (the directory is full) */
      return -1;
   }
   memset(f, 0, sizeof(*f));
   f->drive = d;
   f->dirsec = dsec;
   f->dirent = dent;
   f->flags = flags;
   f->bufsec = -1;
   p = sec + dent * 32;		/* (lookup() left its sector there) */
   if (found)
   {
      f->first = p[13];
      if ((f->size = fsize(d, p[13], p[14] << 8 | p[15])) < 0)
      {
	 errno = EIO;
	 return -1;
      }
      if ((flags & O_TRUNC) && (flags & O_ACCMODE) != O_RDONLY &&
	  f->size > 0)
      {
	 freegrans(d, fat[d][f->first]);
	 fat[d][f->first] = LAST;
	 f->size = 0;
	 f->changed = 1;
      }
   }
   else
   {
      /* (lookup() left the last sector it read, not the free entry's) */
      if (disk(READ, d, DIRTRACK, dsec, sec) < 0 || (g = newgran(d)) < 0)
	 return -1;
      memset(p, 0, 32);
      memcpy(p, ent, 11);
      p[11] = 1;		/* data */
      p[12] = 0xff;		/* ASCII */
      p[13] = g;
      f->first = g;
      if (disk(WRITE, d, DIRTRACK, dsec, sec) < 0 || savefat(d) < 0)
	 return -1;
   }
   f->open = 1;
   __cb_files = &ops;
   return fd + CB_FIRSTFILE;
}

static struct dfile *
fileof(fd)
int fd;
{
   fd -= CB_FIRSTFILE;
   if (fd < 0 || fd >= NFILES || !files[fd].open)
   {
      errno = EBADF;
      return 0;
   }
   return &files[fd];
}

static int
dread(fd, buf, n)
int fd;
char *buf;
int n;
{
   struct dfile *f;
   int done = 0, k, off;

   if ((f = fileof(fd)) == 0)
      return -1;
   if ((f->flags & O_ACCMODE) == O_WRONLY)
   {
      errno = EBADF;
      return -1;
   }
   while (done < n && f->pos < f->size)
   {
      if (load(f, (int) (f->pos / SECSIZE)) < 0)
	 return done ? done : -1;
      off = f->pos % SECSIZE;
      k = SECSIZE - off;
      if (k > n - done)
	 k = n - done;
      if (k > f->size - f->pos)
	 k = f->size - f->pos;
      memcpy(buf + done, f->buf + off, k);
      done += k;
      f->pos += k;
   }
   return done;
}

static int
dwrite(fd, buf, n)
int fd;
char *buf;
int n;
{
   struct dfile *f;
   int done = 0, k, off;

   if ((f = fileof(fd)) == 0)
      return -1;
   if ((f->flags & O_ACCMODE) == O_RDONLY)
   {
      errno = EBADF;
      return -1;
   }
   if (f->flags & O_APPEND)
      f->pos = f->size;
   while (done < n)
   {
      /* (the sector's granule first: on a full disk, no more is
	 written, and the file holds what its granules do) */
      if (f->pos >= (long) NGRANS * GRANSIZE)
      {
	 errno = ENOSPC;
	 break;
      }
      if (granof(f, (int) (f->pos / SECSIZE), 1) < 0 ||
	  load(f, (int) (f->pos / SECSIZE)) < 0)
	 break;
      off = f->pos % SECSIZE;
      k = SECSIZE - off;
      if (k > n - done)
	 k = n - done;
      memcpy(f->buf + off, buf + done, k);
      f->dirty = 1;
      done += k;
      f->pos += k;
      if (f->pos > f->size)
      {
	 f->size = f->pos;
	 f->changed = 1;
      }
   }
   return done ? done : -1;
}

static long
dlseek(fd, offset, whence)
int fd;
long offset;
int whence;
{
   struct dfile *f;

   if ((f = fileof(fd)) == 0)
      return -1L;
   if (whence == SEEK_CUR)
      offset += f->pos;
   else if (whence == SEEK_END)
      offset += f->size;
   else if (whence != SEEK_SET)
      offset = -1;
   if (offset < 0 || offset > f->size)
   {
      errno = EINVAL;
      return -1L;
   }
   f->pos = offset;
   return offset;
}

/* the granules the file's size needs (at least 1), the last marked with
   its sectors used, and its entry's bytes in the last sector */
static int
finish(f)
struct dfile *f;
{
   unsigned char *ft = fat[f->drive];
   long rest = f->size;
   int g, nsec, last;

   g = f->first;
   while (rest > GRANSIZE)
   {
      if (ft[g] >= NGRANS)
      {
	 errno = EIO;		/* (dwrite() made them) */
	 return -1;
      }
      g = ft[g];
      rest -= GRANSIZE;
   }
   if (ft[g] < NGRANS)
      freegrans(f->drive, ft[g]);
   nsec = (int) ((rest + SECSIZE - 1) / SECSIZE);
   last = nsec ? (int) (rest - (long) (nsec - 1) * SECSIZE) : 0;
   ft[g] = LAST + nsec;
   if (disk(READ, f->drive, DIRTRACK, f->dirsec, sec) < 0)
      return -1;
   sec[f->dirent * 32 + 14] = last >> 8;
   sec[f->dirent * 32 + 15] = last;
   if (disk(WRITE, f->drive, DIRTRACK, f->dirsec, sec) < 0)
      return -1;
   return savefat(f->drive);
}

static int
dclose(fd)
int fd;
{
   struct dfile *f;
   int r = 0, e = 0;

   if ((f = fileof(fd)) == 0)
      return -1;
   if (flush(f) < 0)
   {
      r = -1;
      e = errno;
   }
   if (f->changed && finish(f) < 0)
      r = -1;
   if (e)
      errno = e;		/* (the first error) */
   f->open = 0;
   return r;
}

/* the file's granules are freed and its entry marked deleted (not while
   it is open here) */
int
unlink(name)
const char *name;
{
   unsigned char ent[11];
   int d, dsec, dent, i, found;

   if (!__cb_hasdisk())
   {
      errno = ENODEV;
      return -1;
   }
   if (parse(name, ent, &d) < 0)
   {
      errno = ENOENT;
      return -1;
   }
   if (opendrive(d) < 0 || (found = lookup(d, ent, &dsec, &dent)) < 0)
      return -1;
   if (!found)
   {
      errno = ENOENT;
      return -1;
   }
   for (i = 0; i < NFILES; i++)
      if (files[i].open && files[i].drive == d &&
	  files[i].dirsec == dsec && files[i].dirent == dent)
      {
	 errno = EBUSY;
	 return -1;
      }
   freegrans(d, sec[dent * 32 + 13]);
   sec[dent * 32] = 0;
   if (disk(WRITE, d, DIRTRACK, dsec, sec) < 0)
      return -1;
   return savefat(d);
}

/* the entry's name changed to new's, which must be on the same drive
   (EINVAL if not) and not there (EEXIST), as FLEX's rename() wants; an
   open file goes on as it was */
int
rename(old, new)
const char *old, *new;
{
   unsigned char from[11], to[11];
   int d, d2, dsec, dent, found;

   if (!__cb_hasdisk())
   {
      errno = ENODEV;
      return -1;
   }
   if (parse(old, from, &d) < 0 || parse(new, to, &d2) < 0)
   {
      errno = ENOENT;
      return -1;
   }
   if (d != d2)
   {
      errno = EINVAL;
      return -1;
   }
   if (opendrive(d) < 0)
      return -1;
   if (memcmp(from, to, 11) != 0)
   {
      if ((found = lookup(d, to, &dsec, &dent)) < 0)
	 return -1;
      if (found)
      {
	 errno = EEXIST;
	 return -1;
      }
   }
   if ((found = lookup(d, from, &dsec, &dent)) < 0)
      return -1;
   if (!found)
   {
      errno = ENOENT;
      return -1;
   }
   memcpy(sec + dent * 32, to, 11);
   return disk(WRITE, d, DIRTRACK, dsec, sec);
}
