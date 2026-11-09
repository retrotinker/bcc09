/* sbrk.c - sbrk() and brk() on OS-9 (bcc09 -Mo), for malloc
 *
 * As stdlib/sbrk.s does elsewhere: the heap starts at _end, the end of the
 * program's data (in OS-9's data area, which U points at, so it is where
 * the code finds it, not where the linker put it), and grows up toward
 * the stack, which grows down from the top of the data area; it may not
 * come within __heap_margin bytes (256 unless the program changes it) of
 * the stack pointer at the time of the call, nor go below _end.
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <errno.h>
#include <unistd.h>

extern char _end[];

unsigned int __heap_margin = 256;
static char *curbrk;		/* the end of the heap (_end at first) */

/* nonzero if the heap may end at p: not below _end, not too near S */
static int
ok(p)
char *p;
{
   char here;			/* (about where S is) */

   return p >= _end && (unsigned) (&here - p) >= __heap_margin &&
      p <= &here;
}

void *
sbrk(incr)
int incr;
{
   char *old;

   if (curbrk == 0)
      curbrk = _end;
   old = curbrk;
   if ((incr > 0 && old + incr < old) || (incr < 0 && old + incr > old)
       || !ok(old + incr))
   {
      errno = ENOMEM;
      return (void *) -1;
   }
   curbrk = old + incr;
   return old;
}

int
brk(addr)
void *addr;
{
   if (!ok(addr))
   {
      errno = ENOMEM;
      return -1;
   }
   curbrk = addr;
   return 0;
}
