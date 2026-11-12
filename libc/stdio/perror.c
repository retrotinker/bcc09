/* perror(s): "s: " (unless s is NULL or empty), strerror(errno), and the
 * end of a line as the system has it (__eol, from each target's
 * library), to stderr
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <stdio.h>
#include <string.h>
#include <errno.h>

extern char __eol[];

void
perror(s)
const char *s;
{
   char *msg = strerror(errno);	/* (before stdio changes errno) */

   if (s && *s)
   {
      fputs(s, stderr);
      fputs(": ", stderr);
   }
   fputs(msg, stderr);
   fputs(__eol, stderr);
}
