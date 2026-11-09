/* flex.h - the FLEX target's (bcc09 -Mf) own: libc's, not installed
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

/* FLEX's routines (flex.s) */
extern int __flex_inch();
extern void __flex_putchr();
extern int __flex_fms();	/* (fcb, a): A, or -error */

/* Descriptors from 3 up are files (file.c), whose functions read(),
   write(), lseek() and close() call through __flex_files, which open()
   sets (so a program that opens no files doesn't carry them). */
#define FLEX_FIRSTFILE	3

struct __flex_fileops
{
   int (*read) ();		/* (fd, buf, n) */
   int (*write) ();		/* (fd, buf, n) */
   long (*lseek) ();		/* (fd, offset, whence) */
   int (*close) ();		/* (fd) */
};

extern struct __flex_fileops *__flex_files;
