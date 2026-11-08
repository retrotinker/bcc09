/* built by bcc09 -Mi (for sim6809): the printf family, over a grid of
   formats and values; it prints each result and the count printf gives,
   which must be the same with the host's C library (the values are chosen
   so that 16-bit and 32-bit ints agree); exits with the number of failed
   checks */

#include <stdio.h>
#include <string.h>

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

static char *flags[] = {
	"", "-", "+", " ", "#", "0", "-+", "+0", " 0", "#0", "-#", "- 0", 0
};
static char *widths[] = { "", "1", "7", 0 };
static char *precs[] = { "", ".0", ".1", ".4", 0 };
static int ivals[] = { 0, 1, -1, 7, -42, 255, 4096, 32767, -32767 };
static unsigned uvals[] = { 0, 1, 8, 42, 255, 4096, 32768U, 65535U };
static long lvals[] = { 0L, 1L, -1L, 65536L, -100000L, 2147483647L };
static unsigned long ulvals[] = { 0L, 65535L, 65536L, 4294967295UL };

#define N(a)	(sizeof(a) / sizeof(a[0]))

/* every combination of flags, width and precision with conversion c */
void grid(c, size)
char *c;
int size;
{
	char fmt[32];
	int f, w, p, v, n;

	for (f = 0; flags[f]; f++)
		for (w = 0; widths[w]; w++)
			for (p = 0; precs[p]; p++) {
				strcpy(fmt, "[%");
				strcat(fmt, flags[f]);
				strcat(fmt, widths[w]);
				strcat(fmt, precs[p]);
				strcat(fmt, c);
				strcat(fmt, "]");
				printf("%s ", fmt);
				if (size == 0 && (*c == 'd' || *c == 'i'))
					for (v = 0; v < N(ivals); v++)
						printf(fmt, ivals[v]);
				else if (size == 0)
					for (v = 0; v < N(uvals); v++)
						printf(fmt, uvals[v]);
				else if (*c == 'l' && (c[1] == 'd'))
					for (v = 0; v < N(lvals); v++)
						printf(fmt, lvals[v]);
				else
					for (v = 0; v < N(ulvals); v++)
						printf(fmt, ulvals[v]);
				/* (not size ? 1L : 1, which is always a long) */
				if (size)
					n = printf(fmt, 1L);
				else
					n = printf(fmt, 1);
				printf(" %d\n", n);
			}
}

void others()
{
	char buf[32];
	int n, m;
	short sh;
	long ln;
	char *np = 0;

	/* characters and strings */
	printf("[%c][%3c][%-3c]\n", 'a', 'b', 'c');
	printf("[%s][%8s][%-8s][%.2s][%8.3s][%-8.3s][%.0s]\n",
	       "hello", "hello", "hello", "hello", "hello", "hello", "hello");
	printf("[%s][%5s]\n", "", "");
	printf("[%s]\n", np);			/* (null), as glibc */
	printf("[%%][%5%]\n");

	/* * for the width and precision, negative too */
	printf("[%*d][%-*d][%*d]\n", 5, 42, 5, 42, -5, 42);
	printf("[%.*d][%.*d][%*.*d]\n", 4, 7, -1, 7, 6, 3, 9);
	printf("[%.*s][%*s]\n", 3, "abcdef", -4, "x");

	/* sizes */
	printf("[%hhd][%hhu][%hhx]\n", 300, 300, 511);
	printf("[%hd][%hu][%ho]\n", -2, 2, 8);
	printf("[%ld][%li][%lu][%lx][%lX][%lo]\n", -1L, 123456L, 3000000000UL,
	       0xdeadbeefUL, 0xcafeUL, 8L);

	/* pointers, as glibc shows them */
	printf("[%p][%10p][%-10p]\n", (void *) 0, (void *) 0, (void *) 0);
	printf("[%p][%8p][%-8p]\n", (void *) 0x1234, (void *) 0x1234,
	       (void *) 0x1234);

	/* %n */
	n = 0;
	printf("abc%ndef\n", &n);
	ok(1, n == 3);
	sh = 0;
	ln = 0;
	printf("%d%hn%ld%ln\n", 12345, &sh, 7L, &ln);
	ok(2, sh == 5 && ln == 6);

	/* sprintf and snprintf, and what they return */
	n = sprintf(buf, "%d-%s", -12, "xy");
	printf("[%s] %d\n", buf, n);
	memset(buf, 'z', sizeof(buf));
	n = snprintf(buf, 6, "%s", "hello, world");
	printf("[%s] %d %c\n", buf, n, buf[6]);
	memset(buf, 'z', sizeof(buf));
	n = snprintf(buf, 1, "abc");
	printf("[%s] %d\n", buf, n);
	buf[0] = 'q';
	n = snprintf(buf, 0, "abc");
	printf("[%c] %d\n", buf[0], n);
	n = snprintf(buf, sizeof(buf), "%05d|%x", 42, 255);
	printf("[%s] %d\n", buf, n);

	/* what printf and fprintf return */
	n = printf("twelve chars");
	m = printf("\n");
	printf("%d %d\n", n, m);
	n = fprintf(stdout, "%s=%d\n", "x", 5);
	printf("%d\n", n);
}

int main()
{
	grid("d", 0);
	grid("i", 0);
	grid("u", 0);
	grid("o", 0);
	grid("x", 0);
	grid("X", 0);
	grid("ld", 1);
	grid("lu", 1);
	grid("lx", 1);
	others();
	printf("checks %d failures %d\n", checks, failures);
	return failures;
}
