/* Copyright (C) 1995,1996 Robert de Bath <rdebath@cix.compulink.co.uk>
 * This file is part of the Linux-8086 C library and is distributed
 * under the GNU Library General Public License.
 */

/* For bcc09: skip leading white space as isspace() defines it */

#include <stdlib.h>
#include <ctype.h>

int
atoi(number)
register const char *number;
{
   register int   n = 0, neg = 0;

   while (isspace(*number))
      ++number;
   if (*number == '-')
   {
      neg = 1;
      ++number;
   }
   else if (*number == '+')
      ++number;
   while (*number>='0' && *number<='9')
      n = (n * 10) + ((*number++) - '0');
   return (neg ? -n : n);
}
