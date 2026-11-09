/* start.c - main(argc, argv) for FLEX (bcc09 -Mf), from the command line
 * that FLEX leaves in its line buffer ($C080, up to a CR), with its line
 * buffer pointer (LPOINT, $CC14) past the running command's name and the
 * blank or comma after it: argv[0] is that name (as typed: "PROG", or
 * "1.PROG" with the drive; the word before LPOINT, so "P,PROG", P's
 * printing of PROG's output, gives PROG), and the rest are the words from
 * LPOINT on, separated by blanks or commas as FLEX's own commands' are;
 * called by crt0
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#define LINBUF	((char *) 0xc080)
#define LINSIZE	128
#define LPOINT	(*(char **) 0xcc14)
#define CR	0x0d
#define MAXARGS	16

extern int main();

static char line[LINSIZE + 1];	/* (a copy: FLEX reuses its buffer) */
static char *argv[MAXARGS + 1];

#define SEP(c)	((c) == ' ' || (c) == ',')

int
__flexstart()
{
   int argc = 0, i, end, name, j;
   char *p;

   for (end = 0; end < LINSIZE && LINBUF[end] != CR; end++)
      line[end] = LINBUF[end];
   line[end] = 0;
   i = LPOINT - LINBUF;		/* (past the name and a separator) */
   if (i < 0 || i > end)
      i = 0;
   for (j = i; j > 0 && SEP(line[j - 1]); j--)
      ;
   for (name = j; name > 0 && !SEP(line[name - 1]); name--)
      ;
   if (j > name)
   {
      argv[argc++] = line + name;
      p = line + (i == j && j < end ? j + 1 : i);
      line[j] = 0;		/* (ends the name; p is past it) */
   }
   else
      p = line;
   while (*p && argc < MAXARGS)
   {
      while (SEP(*p))
	 p++;
      if (*p == 0)
	 break;
      argv[argc++] = p;
      while (*p && !SEP(*p))
	 p++;
      if (*p)
	 *p++ = 0;
   }
   argv[argc] = 0;
   return main(argc, argv);
}
