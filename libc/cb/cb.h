/* cb.h - the Color BASIC target's (bcc09 -Me) own: libc's, not installed
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

/* the ROM's routines (rom.s) */
extern int __cb_polcat();
extern void __cb_chrout();
extern int __cb_dskcon();	/* (op, drive, track, sector, buf): DCSTA */
extern int __cb_hasdisk();

/* Descriptors from 3 up are disk files (disk.c), whose functions read(),
   write(), lseek() and close() call through __cb_files, which open() sets
   (so a program that opens no files doesn't carry them). */
#define CB_FIRSTFILE	3

struct __cb_fileops
{
   int (*read) ();		/* (fd, buf, n) */
   int (*write) ();		/* (fd, buf, n) */
   long (*lseek) ();		/* (fd, offset, whence) */
   int (*close) ();		/* (fd) */
};

extern struct __cb_fileops *__cb_files;
