/* built by bcc09 -Mi (for sim6809): stdio's FILE functions, with
   siotest.in as the input; the simulator's output is like a terminal's,
   so stdout is line buffered and stderr unbuffered; checks are printed
   as FAIL n, and it exits with the number that failed */

#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>

int checks, failures;

void ok(n, cond)
int n, cond;
{
	++checks;
	if (!cond) {
		++failures;
		printf("FAIL %d\n", n);
	}
}

void output()
{
	char buf[BUFSIZ];

	ok(1, puts("puts") >= 0);
	ok(2, fputs("fputs, ", stdout) >= 0);
	putc('p', stdout);
	putchar('c');
	ok(3, fputc('\n', stdout) == '\n');
	ok(4, fwrite("fwrite\n", 1, 7, stdout) == 7);

	/* stdout waits for a newline; stderr doesn't wait */
	printf("[line ");
	fprintf(stderr, "(stderr)");
	printf("buffered]\n");

	/* unbuffered: each piece as it comes */
	ok(5, setvbuf(stdout, (char *) 0, _IONBF, 0) == 0);
	printf("[un");
	write(1, "+", 1);
	printf("buffered]\n");

	/* fully buffered: nothing until fflush */
	ok(6, setvbuf(stdout, buf, _IOFBF, sizeof(buf)) == 0);
	printf("[full]\n");
	write(1, "(before the flush)\n", 19);
	ok(7, fflush(stdout) == 0);

	/* and back to line buffering, with a buffer from malloc */
	ok(8, setvbuf(stdout, (char *) 0, _IOLBF, BUFSIZ) == 0);
	printf("[line again ");
	write(1, "+", 1);
	printf("]\n");
}

void input()
{
	char buf[32];
	int c, n;

	c = getchar();
	ok(10, c == 'f');
	ok(11, ungetc(c, stdin) == 'f');
	ok(12, getchar() == 'f');
	ok(13, fgets(buf, 5, stdin) == buf && strcmp(buf, "irst") == 0);
	ok(14, fgets(buf, sizeof(buf), stdin) == buf
	   && strcmp(buf, " line\n") == 0);
	ok(15, fgets(buf, sizeof(buf), stdin) == buf
	   && strcmp(buf, "second\n") == 0);
	ok(16, fgets(buf, 0, stdin) == 0);
	n = 0;
	while ((c = getc(stdin)) != '\n' && c != EOF)
		buf[n++] = c;
	buf[n] = 0;
	ok(17, strcmp(buf, "12 34") == 0);
	n = fread(buf, 1, sizeof(buf) - 1, stdin);
	buf[n > 0 ? n : 0] = 0;
	ok(18, n == 20 && strcmp(buf, "last without newline") == 0);
	ok(19, getchar() == EOF && feof(stdin) && !ferror(stdin));
	ok(20, ungetc(EOF, stdin) == EOF && feof(stdin));
	ok(21, ungetc('x', stdin) == 'x' && !feof(stdin));
	ok(22, getchar() == 'x' && getchar() == EOF);
	clearerr(stdin);
	ok(23, !feof(stdin));
}

void files()
{
	FILE *fp1, *fp2;

	errno = 0;
	ok(30, fopen("nofile", "r") == 0 && errno == ENOENT);
	ok(31, fopen("nofile", "q") == 0);		/* a bad mode */

	/* two more FILEs on fd 1; closing the older one must leave the
	   newer one's output to be written at exit (fclose once lost it) */
	fp1 = fdopen(1, "w");
	fp2 = fdopen(1, "w");
	ok(32, fp1 != 0 && fp2 != 0 && fileno(fp2) == 1);
	fprintf(fp1, "[fp1]\n");
	fprintf(fp2, "[fp2, written at exit]");
	ok(33, fclose(fp1) == 0);
}

int main()
{
	output();
	input();
	files();
	printf("checks %d failures %d\n", checks, failures);
	printf("[stdout, written at exit]");
	return failures;
}
