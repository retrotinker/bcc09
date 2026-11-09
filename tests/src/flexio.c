/* built by bcc09 -Mf (FLEX) alone and run by sim6809 --flex (with the
   parameters "one,two three" and flexio.in as the input): the arguments
   from FLEX's line buffer (separated by commas or blanks); lines read with getdelim() (they end with CR) and
   written back in upper case, with CR LF, as FLEX's terminal wants;
   stdio; the heap; bad file descriptors; and the exit status (sim6809's
   convention: B at WARMS), the number of lines read */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <errno.h>
#include <unistd.h>

int main(argc, argv)
int argc;
char **argv;
{
	char *line = 0, *p;
	size_t size = 0;
	int i, n, lines = 0;

	for (i = 0; i < argc; i++)
		printf("argv[%d] [%s]\r\n", i, argv[i]);
	while ((n = getdelim(&line, &size, '\r', stdin)) > 0) {
		lines++;
		for (i = 0; i < n; i++)
			line[i] = toupper(line[i]);
		printf("%d: [%.*s]\r\n", n, n - 1, line);
	}
	p = malloc(20000);
	printf("malloc %s\r\n", p ? "ok" : "failed");
	errno = 0;
	i = write(3, "x", 1);	/* (apart: arguments are evaluated in any order) */
	printf("write(3) %d %d\r\n", i, errno == EBADF);
	printf("isatty %d %d\r\n", isatty(0), isatty(1));
	printf("fopen %d\r\n", fopen("NOFILE.TXT", "r") == 0);
	return lines;
}
