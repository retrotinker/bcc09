/* start.c - main's arguments on OS-9 (bcc09 -Mo), for the start-up code
 * (os9/crt0.s)
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#define MAXARGS	32
#define CR	0x0d		/* (OS-9's end of a line; '\n' with -Mo) */

static char *argv[MAXARGS + 1];
static char name[32];

extern int main();

/* main(argc, argv) from the parameters (len bytes at params, the last a
   CR): argv[0] is the module's name (at mname, its last character with
   bit 7 set), then each word of the parameters (blanks separate them; a
   word in "" may have blanks); returns main's result */
int
__os9start(params, mname, len)
char *params;
char *mname;
int len;
{
   char *p = params, *end = params + len;
   int argc = 0, i;

   for (i = 0; i < sizeof(name) - 1; i++)
   {
      name[i] = mname[i] & 0x7f;
      if (mname[i] & 0x80)
      {
	 i++;
	 break;
      }
   }
   name[i] = '\0';
   argv[argc++] = name;

   while (p < end && argc < MAXARGS)
   {
      while (p < end && (*p == ' ' || *p == '\t'))
	 p++;
      if (p >= end || *p == CR)
	 break;
      if (*p == '"')
      {
	 argv[argc++] = ++p;
	 while (p < end && *p != '"' && *p != CR)
	    p++;
      }
      else
      {
	 argv[argc++] = p;
	 while (p < end && *p != ' ' && *p != '\t' && *p != CR)
	    p++;
      }
      if (p < end)
      {
	 if (*p == CR)
	 {
	    *p = '\0';
	    break;
	 }
	 *p++ = '\0';
      }
   }
   argv[argc] = 0;
   return main(argc, argv);
}
