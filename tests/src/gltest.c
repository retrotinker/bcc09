/* built by bcc09 -Mi (for sim6809): POSIX's getline() and getdelim(),
   reading gltest.in: lines shorter and longer than the buffer they start
   with, OS-9's and Color BASIC's lines (ending with '\r'), other
   delimiters, a last line with no delimiter, the end of the file, and
   errors; prints what each read gives (but not the buffers' sizes,
   which may differ), which must be the same with the host's C library */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

/* r and the line, with \r and \n shown */
void show(what, r, line)
char *what;
int r;
char *line;
{
	char *p;

	printf("%s: %d [", what, r);
	if (r > 0)
		for (p = line; *p; p++)
			if (*p == '\r')
				printf("\\r");
			else if (*p == '\n')
				printf("\\n");
			else
				putchar(*p);
	printf("]\n");
}

int main()
{
	char *line = 0, *small;
	size_t size = 0;
	int r, i;

	/* lines, the third longer than 64, then three ending with '\r' */
	for (i = 0; i < 3; i++) {
		r = getline(&line, &size, stdin);
		show("getline", r, line);
	}
	printf("length %d, size enough %d\n", (int) strlen(line),
	       size > strlen(line));
	for (i = 0; i < 3; i++) {
		r = getdelim(&line, &size, '\r', stdin);
		show("getdelim CR", r, line);
	}

	/* a buffer of its own, smaller than the line */
	small = malloc(4);
	size = 4;
	r = getline(&small, &size, stdin);
	show("small", r, small);
	free(small);

	/* fields ending with ':', and the rest of their line */
	for (i = 0; i < 2; i++) {
		r = getdelim(&line, &size, ':', stdin);
		show("getdelim :", r, line);
	}
	r = getline(&line, &size, stdin);
	show("rest", r, line);

	/* the last line has no '\n'; then the end of the file */
	r = getline(&line, &size, stdin);
	show("last", r, line);
	r = getline(&line, &size, stdin);
	show("end", r, line);
	r = getline(&line, &size, stdin);
	show("end again", r, line);
	free(line);

	/* errors: a null pointer for the line or the size (the host's
	   C library says they mustn't be, so only bcc09's is asked) */
	r = 1;
#ifdef __BCC__
	errno = 0;
	r = getline((char **) 0, &size, stdin) == -1 && errno == EINVAL;
	errno = 0;
	line = 0;
	r = r && getdelim(&line, (size_t *) 0, '\n', stdin) == -1 &&
		errno == EINVAL;
#endif
	printf("errors %d\n", r);
	return 0;
}
