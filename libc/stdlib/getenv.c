/* getenv(name), system(command): bcc09's systems give a program no
 * environment and have no command processor it can call, so getenv()
 * finds nothing (NULL), and system(NULL) says there's none (0), and
 * system(command) fails (-1); each compiled separately (-DL_getenv,
 * -DL_system)
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <stdlib.h>

#ifdef L_getenv
char *
getenv(name)
const char *name;
{
   return 0;
}
#endif

#ifdef L_system
int
system(command)
const char *command;
{
   return command ? -1 : 0;
}
#endif
