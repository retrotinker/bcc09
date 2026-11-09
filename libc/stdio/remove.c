/* remove(): deletes a file, as unlink() does (on the targets that have
 * files)
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <stdio.h>
#include <unistd.h>

int
remove(name)
const char *name;
{
   return unlink(name);
}
