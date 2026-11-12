/* fgetpos(fp, pos), fsetpos(fp, pos): ftell() and fseek() with a fpos_t
 * (a long); 0, or -1 with errno set; each compiled separately
 * (-DL_fgetpos, -DL_fsetpos)
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <stdio.h>

#ifdef L_fgetpos
int
fgetpos(fp, pos)
FILE *fp;
fpos_t *pos;
{
   long p = ftell(fp);

   if (p < 0)
      return -1;
   *pos = p;
   return 0;
}
#endif

#ifdef L_fsetpos
int
fsetpos(fp, pos)
FILE *fp;
const fpos_t *pos;
{
   return fseek(fp, *pos, SEEK_SET) ? -1 : 0;
}
#endif
