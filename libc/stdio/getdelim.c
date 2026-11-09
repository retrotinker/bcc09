/* getdelim.c - POSIX's getdelim() and getline(), each compiled separately
 * (-DL_name)
 *
 * getdelim(&line, &size, delim, fp) reads from fp up to and including the
 * byte delim, or to the end of the file, into *line, a buffer of *size
 * bytes from malloc (or a null pointer: then *size doesn't matter), which
 * it makes bigger with realloc when it must; it ends what it read with a
 * 0, and returns its length (with delim, without the 0), or -1 at the end
 * of the file with nothing read, or for an error (errno EINVAL if line or
 * size is a null pointer, ENOMEM if no memory is left).  getline() is
 * getdelim() with '\n'.  For the lines of OS-9 (bcc09 -Mo) and Color
 * BASIC (-Me), which end with a CR, use getdelim(..., '\r', fp).
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

#ifdef L_getdelim
ssize_t
getdelim(line, size, delim, fp)
char **line;
size_t *size;
int delim;
FILE *fp;
{
   size_t n = 0, want;
   char *p;
   int c;

   if (line == 0 || size == 0)
   {
      errno = EINVAL;
      return -1;
   }
   if (*line == 0)
      *size = 0;
   for (;;)
   {
      if (n + 2 > *size)	/* room for this byte and the 0 */
      {
	 want = *size < 64 ? 64 : *size * 2;
	 if (want <= *size || (p = realloc(*line, want)) == 0)
	 {
	    errno = ENOMEM;
	    return -1;
	 }
	 *line = p;
	 *size = want;
      }
      if ((c = getc(fp)) == EOF)
	 break;
      (*line)[n++] = c;
      if (c == (delim & 0xff))
	 break;
   }
   (*line)[n] = 0;
   if (n == 0)
      return -1;		/* (the end of the file, or an error) */
   return n;
}
#endif

#ifdef L_getline
ssize_t
getline(line, size, fp)
char **line;
size_t *size;
FILE *fp;
{
   return getdelim(line, size, '\n', fp);
}
#endif
