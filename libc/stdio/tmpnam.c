/* tmpnam(s), tmpfile(): temporary files.  tmpnam() gives a name, TMPnnnnn
 * (which FLEX, Disk BASIC and OS-9 all take), that no file has, in s or
 * its own buffer; tmpfile() opens a new file of such a name for update
 * ("wb+"), which is removed when it is closed, or at exit (__stdio_closed,
 * which fclose() and exit() call).  FLEX can't open a file for update, so
 * tmpfile() fails there.  Each compiled separately (-DL_tmpnm,
 * -DL_tmpfile).
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <stdio.h>
#include <errno.h>

#ifdef L_tmpnm
static unsigned count;

char *
tmpnam(s)
char *s;
{
   static char buf[L_tmpnam];
   FILE *fp;
   unsigned n;
   int i, tries;

   if (s == NULL)
      s = buf;
   for (tries = 0; tries < TMP_MAX; tries++)
   {
      n = count++ % TMP_MAX;
      s[0] = 'T';
      s[1] = 'M';
      s[2] = 'P';
      for (i = 7; i >= 3; i--, n /= 10)
	 s[i] = '0' + n % 10;
      s[8] = 0;
      if ((fp = fopen(s, "r")) == NULL)
	 return s;
      fclose(fp);
   }
   return NULL;
}
#endif

#ifdef L_tmpfile
extern void (*__stdio_closed)();

static struct
{
   FILE *fp;
   char name[L_tmpnam];
} tmps[FOPEN_MAX];

/* a stream has been closed: if it is one of ours, remove its file */
static void
closed(fp)
FILE *fp;
{
   int i;

   for (i = 0; i < FOPEN_MAX; i++)
      if (tmps[i].fp == fp)
      {
	 tmps[i].fp = NULL;
	 remove(tmps[i].name);
      }
}

FILE *
tmpfile()
{
   FILE *fp;
   int i;

   for (i = 0; i < FOPEN_MAX && tmps[i].fp; i++)
      ;
   if (i == FOPEN_MAX)
   {
      errno = EMFILE;
      return NULL;
   }
   if (tmpnam(tmps[i].name) == NULL || (fp = fopen(tmps[i].name, "wb+")) == NULL)
      return NULL;
   tmps[i].fp = fp;
   __stdio_closed = closed;
   return fp;
}
#endif
