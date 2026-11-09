/* scan.h - the scanf family's input, shared by scanf.c and scanfp.c:
 * libc's own, not installed
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

/* where the characters come from: a FILE, or a string if fp is 0 */
struct __scan
{
   FILE *fp;
   const char *s;
   int count;			/* characters read, for %n */
};

extern int __scget();		/* (sc): the next character, or EOF */
extern void __scunget();	/* (c, sc): put back c, the last got */

/* %a, %e, %f and %g, if linked (see xfptvc.s): (sc, width, p, size)
   reads a number of up to width characters and stores it at p (if not 0)
   as a float (size 0) or a double (1); returns 1, or 0 if there was no
   number (a matching failure) */
extern int (*__scanfp_hook)();
