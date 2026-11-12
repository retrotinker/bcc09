/* __assert(e, file, line): assert(e) failed (assert.h): write
 * "file:line: assertion failed: e", and the end of a line, to stderr,
 * and abort()
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <stdio.h>
#include <stdlib.h>

extern char __eol[];

void
__assert(e, file, line)
const char *e, *file;
int line;
{
   fputs(file, stderr);
   fputs(":", stderr);
   fputs(itoa(line), stderr);
   fputs(": assertion failed: ", stderr);
   fputs(e, stderr);
   fputs(__eol, stderr);
   abort();
}
