/* Copyright (C) 1995,1996 Robert de Bath <rdebath@cix.compulink.co.uk>
 * This file is part of the Linux-8086 C library and is distributed
 * under the GNU Library General Public License.
 */

/* For bcc09: compare the lower case letters, and return their difference
   (see strcasecmp.c) */

#include <string.h>
#include <ctype.h>

int
strncasecmp(s, d, l)
const char *s;
const char *d;
size_t l;
{
   register int c1, c2;

   while(l>0)
   {
      c1 = tolower(*s);
      c2 = tolower(*d);
      if( c1 != c2 ) return c1 - c2;
      if( c1 == '\0' ) return 0;
      s++; d++; l--;
   }
   return 0;
}
