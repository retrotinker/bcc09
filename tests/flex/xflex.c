/* run on real FLEX (Compusense FLEX for the Dragon 64) in XRoar (see
   run.sh): built by bcc09 -Mf, run as "P,XFLEX one,two three" (its output
   printed too); prints its arguments (the word before FLEX's line buffer
   pointer, and the words after it), and checks the heap, stdio, isatty
   and errors, printing the failed checks and their number (FLEX has no
   exit status); lines end with CR LF, as FLEX's terminal and printer
   want */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>

int checks, failures;

void ok(n, cond)
int n, cond;
{
	++checks;
	if (!cond) {
		++failures;
		printf("FAIL %d\r\n", n);
	}
}

int main(argc, argv)
int argc;
char **argv;
{
	char buf[40], *p, *q;
	int i;

	for (i = 0; i < argc; i++)
		printf("argv[%d] [%s]\r\n", i, argv[i]);
	ok(1, argc == 4 && argv[4] == 0);

	p = malloc(20000);
	ok(2, p != 0);
	if (p) {
		memset(p, 0x5a, 20000);
		ok(3, p[0] == 0x5a && p[19999] == 0x5a);
		q = malloc(100);
		ok(4, q != 0 && (q >= p + 20000 || q + 100 <= p));
		free(q);
		free(p);
	}
	sprintf(buf, "%d %s %5.2f", 42, "flex", 3.14159);
	ok(5, strcmp(buf, "42 flex  3.14") == 0);
	ok(6, isatty(1));
	errno = 0;
	i = write(3, "x", 1);
	ok(7, i == -1 && errno == EBADF);
	errno = 0;
	ok(8, fopen("NOFILE.TXT", "r") == 0 && errno == ENOENT);
	printf("checks %d failures %d\r\n", checks, failures);
	return failures;
}
