/* sbrk.c - sbrk() and brk() on OS-9 (bcc09 -Mo), for malloc
 *
 * The heap grows from the end of the data area F$Fork gave the program
 * (__dtop, which crt0 keeps, as it does where the data area starts,
 * __dbase): F$Mem makes the data area bigger to make room, in whole pages
 * (and Level 1 can do that only if the memory after it is free).  The
 * stack has the rest of the data area, down from the parameters at its
 * top (objcopy09 -d sets its size), so the two don't meet.  brk() can't
 * move the end of the heap below __dtop; memory given back isn't
 * returned to OS-9.
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <errno.h>
#include <unistd.h>
#include "os9.h"

char *__dbase, *__dtop;		/* the data area (crt0.s) */
unsigned int __heap_margin = 256;	/* (unistd.h; not used on OS-9) */
static char *curbrk;		/* the end of the heap (__dtop at first) */
static char *memtop;		/* the end of the memory F$Mem gave */

/* 0 if the heap may end at p: getting the memory for it if need be */
static int
setbrk(p)
char *p;
{
   struct os9regs r;

   OS9_CLEAR(&r);
   if (curbrk == 0)
      curbrk = memtop = __dtop;
   if (p < __dtop)
      return -1;
   if (p > memtop)
   {
      r.a = (unsigned) (p - __dbase) >> 8;
      r.b = (unsigned) (p - __dbase);
      __os9call(&r, OS9_MEM);
      if (OS9_FAILED(&r))
	 return -1;
      memtop = (char *) r.y;
   }
   curbrk = p;
   return 0;
}

void *
sbrk(incr)
int incr;
{
   char *old;

   if (curbrk == 0)
      curbrk = memtop = __dtop;
   old = curbrk;
   if ((incr > 0 && old + incr < old) || (incr < 0 && old + incr > old)
       || setbrk(old + incr) < 0)
   {
      errno = ENOMEM;
      return (void *) -1;
   }
   return old;
}

int
brk(addr)
void *addr;
{
   if (setbrk(addr) < 0)
   {
      errno = ENOMEM;
      return -1;
   }
   return 0;
}
