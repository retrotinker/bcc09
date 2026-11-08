/* Copyright (C) 1995,1996 Robert de Bath <rdebath@cix.compulink.co.uk>
 * This file is part of the Linux-8086 C library and is distributed
 * under the GNU Library General Public License.
 */

/* The basic string package from the dev86 C library, for bcc09: the C
 * versions, without the 8086 assembly ones.  Each function is compiled
 * separately (with -DL_name), so that a program links only what it uses.
 * memcpy is in memcpy.s, and strdup will come with malloc.
 *
 * Changes from dev86: strncat called memchr with its arguments in the
 * wrong order; memcmp compared its operands the wrong way round; and
 * strchr, strrchr, memchr and memccpy now convert c to a char, as C
 * requires.
 */

#include <string.h>

/********************** Function strlen ************************************/

#ifdef L_strlen
size_t strlen(str)
const char * str;
{
   register char * p =(char *) str;
   while(*p) p++;
   return p-str;
}
#endif

/********************** Function strcat ************************************/

#ifdef L_strcat
char * strcat(d, s)
char *d;
const char * s;
{
   (void) strcpy(d+strlen(d), s);
   return d;
}
#endif

/********************** Function strcpy ************************************/

#ifdef L_strcpy
char * strcpy(d, s)
char *d;
const char * s;
{
   /* This is probably the quickest on an 8086 but a CPU with a cache will
    * prefer to do this in one pass */
   return memcpy(d, s, strlen(s)+1);
}
#endif

/********************** Function strcmp ************************************/

#ifdef L_strcmp
int strcmp(d, s)
const char *d;
const char * s;
{
   /* Bytes compare as unsigned char, which bcc09's char is */
   register char *s1=(char *)d, *s2=(char *)s, c1,c2;
   while((c1= *s1++) == (c2= *s2++) && c1 );
   return c1 - c2;
}
#endif

/********************** Function strncat ************************************/

#ifdef L_strncat
char * strncat(d, s, l)
char *d;
const char *s;
size_t l;
{
   register char *s1=d+strlen(d), *s2;

   s2 = memchr(s, 0, l);
   if( s2 )
      memcpy(s1, s, s2-s+1);
   else
   {
      memcpy(s1, s, l);
      s1[l] = '\0';
   }
   return d;
}
#endif

/********************** Function strncpy ************************************/

#ifdef L_strncpy
char * strncpy(d, s, l)
char *d;
const char *s;
size_t l;
{
   register char *s1=d, *s2=(char *)s;
   while(l > 0)
   {
      l--;
      if( (*s1++ = *s2++) == '\0')
         break;
   }

   /* This _is_ correct strncpy is supposed to zap */
   for(; l>0; l--) *s1++ = '\0';
   return d;
}
#endif

/********************** Function strncmp ************************************/

#ifdef L_strncmp
int strncmp(d, s, l)
const char *d, *s;
size_t l;
{
   register char c1=0, c2=0;
   while(l-- >0)
      if( (c1= *d++) != (c2= *s++) || c1 == '\0' )
         break;
   return c1-c2;
}
#endif

/********************** Function strchr ************************************/

#ifdef L_strchr
char *
strchr(s, c)
const char * s;
int c;
{
   register char ch, cc = c;
   for(;;)
   {
     if( (ch= *s) == cc ) return (char *) s;
     if( ch == 0 ) return 0;
     s++;
   }
}
#endif

/********************** Function strrchr ************************************/

#ifdef L_strrchr
char * strrchr(s, c)
const char * s;
int c;
{
   register char * prev = 0;
   register char * p = (char *) s;
   register char cc = c;
   /* For null it's just like strlen */
   if( cc == '\0' ) return p+strlen(p);

   /* everything else just step along the string. */
   while( (p=strchr(p, cc)) != 0 )
   {
      prev = p; p++;
   }
   return prev;
}
#endif

/********************** Function memccpy ************************************/

#ifdef L_memccpy
void * memccpy(d, s, c, l)
void *d;
const void *s;
int c;
size_t l;
{
   register char *s1=d, *s2=(char *)s;
   register char cc = c;
   while(l-- > 0)
      if((*s1++ = *s2++) == cc )
         return s1;
   return 0;
}
#endif

/********************** Function memchr ************************************/

#ifdef L_memchr
void * memchr(str, c, l)
const void * str;
int c;
size_t l;
{
   register char *p=(char *)str;
   register char cc = c;
   while(l-- > 0)
   {
      if(*p == cc) return p;
      p++;
   }
   return 0;
}
#endif

/********************** Function memset ************************************/

#ifdef L_memset
void * memset(str, c, l)
void * str;
int c;
size_t l;
{
   register char *s1=str;
   while(l-->0) *s1++ = c;
   return str;
}
#endif

/********************** Function memcmp ************************************/

#ifdef L_memcmp
int memcmp(s, d, l)
const void *s, *d;
size_t l;
{
   register char *s1=(char *)s, *s2=(char *)d;
   register char c1=0, c2=0;
   while(l-- > 0)
      if( (c1= *s1++) != (c2= *s2++) )
         break;
   return c1-c2;
}
#endif

/********************** Function memmove ************************************/

#ifdef L_memmove
void *
memmove(d, s, l)
void *d;
const void *s;
size_t l;
{
   register char *s1=d, *s2=(char *)s;
   /* This bit of sneakyness c/o Glibc, it assumes the test is unsigned */
   if( s1-s2 >= l ) return memcpy(d,s,l);

   /* This reverse copy only used if we absolutly have to */
   s1+=l; s2+=l;
   while(l-- >0)
      *(--s1) = *(--s2);
   return d;
}
#endif
