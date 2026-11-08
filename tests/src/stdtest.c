/* run on sim6809: libc's ctype.h and stdlib.h functions; exits with the
   number of failed checks.  It is plain C, so that it also builds on
   the host with its own C library (with tests/host/putnum.c for output),
   where it must print the same: that checks the expected results.  The
   checks that depend on int being 16 bits or long 32 (bcc09's sizes),
   or that use functions only libc has (itoa, ltoa, ...), only run on
   sim6809. */

#include <ctype.h>
#include <errno.h>
#include <limits.h>
#include <stdlib.h>
#include <string.h>

extern int putchar();
extern void putnum();

int checks, failures;

void say(s)
char *s;
{
	while (*s)
		putchar(*s++);
}

/* a failed check prints its number */
void ok(n, cond)
int n, cond;
{
	++checks;
	if (!cond) {
		++failures;
		say("FAIL ");
		putnum(n);
	}
}

int sign(n)
int n;
{
	return n < 0 ? -1 : n > 0;
}

/* print a long in decimal (the same on any host) */
void putlong(l)
long l;
{
	char buf[12];
	char *p = buf + sizeof(buf);
	unsigned long u = l;

	if (l < 0)
		u = -u;
	*--p = 0;
	do {
		*--p = '0' + (int) (u % 10);
		u /= 10;
	} while (u);
	if (l < 0)
		*--p = '-';
	say(p);
	putchar('\n');
}

/* each class, over EOF and all 256 characters, as a string of 0s and 1s
   (in lines of 64): the host's C library gives the expected answer */
void classes()
{
	static char *names[] = {
		"alnum", "alpha", "cntrl", "digit", "graph", "lower",
		"print", "punct", "space", "upper", "xdigit", 0
	};
	int i, c, r;

	for (i = 0; names[i]; i++) {
		say(names[i]);
		putchar('\n');
		for (c = -1; c < 256; c++) {
			switch (i) {
			case 0: r = isalnum(c); break;
			case 1: r = isalpha(c); break;
			case 2: r = iscntrl(c); break;
			case 3: r = isdigit(c); break;
			case 4: r = isgraph(c); break;
			case 5: r = islower(c); break;
			case 6: r = isprint(c); break;
			case 7: r = ispunct(c); break;
			case 8: r = isspace(c); break;
			case 9: r = isupper(c); break;
			default: r = isxdigit(c); break;
			}
			putchar(r ? '1' : '0');
			if ((c & 63) == 63)
				putchar('\n');
		}
		putchar('\n');
	}
	say("toupper tolower\n");
	for (c = -1; c < 256; c++)
		if (toupper(c) != c || tolower(c) != c) {
			putnum(c);
			putnum(toupper(c));
			putnum(tolower(c));
		}
}

void cases()
{
	ok(10, strcasecmp("Hello", "hELLO") == 0);
	ok(11, sign(strcasecmp("a", "B")) == -1);	/* dev86: wrong sign */
	ok(12, sign(strcasecmp("B", "a")) == 1);
	ok(13, sign(strcasecmp("abc", "ABCD")) == -1);
	ok(14, strcasecmp("", "") == 0);
	ok(15, strncasecmp("abcX", "ABCy", 3) == 0);
	ok(16, sign(strncasecmp("abcX", "ABCy", 4)) == -1);
	ok(17, strncasecmp("a", "b", 0) == 0);
	ok(18, sign(strncasecmp("Ab", "aC", 5)) == -1);
}

/* strtol and friends: the value (printed), and how far it read */
void conv(s, base)
char *s;
int base;
{
	char *end;

	say(s);
	putchar('\n');
	putlong(strtol(s, &end, base));
	putnum(end - s);
	putlong((long) strtoul(s, &end, base) & 0xffffL);
	putnum(end - s);
}

void numbers()
{
	char *end;

	putnum(atoi("123"));
	putnum(atoi("  -45x"));
	putnum(atoi("+7"));
	putnum(atoi("\t\n 9"));
	putnum(atoi("x9"));
	putlong(atol("  -100000"));
	putlong(atol("2147483647"));

	conv("0", 10);
	conv("  -1234", 10);
	conv("+99 bottles", 10);
	conv("12a", 10);		/* dev86 took the a as a digit */
	conv("z", 36);
	conv("0x1F", 16);
	conv("0x1F", 0);
	conv("0X1f", 0);
	conv("0x", 0);			/* just the 0: end at the x */
	conv("0xg", 16);
	conv("017", 0);
	conv("08", 0);			/* octal: 0, then 8 isn't a digit */
	conv("101", 2);
	conv("777", 8);
	conv("ff", 16);
	conv("-ff", 16);
	conv("", 10);			/* no digits: end is the start */
	conv("   ", 10);
	conv("-", 10);
	conv("+x", 10);

#ifdef __BCC__
	/* a bad base: undefined, but libc reads nothing (glibc leaves end
	   unset) */
	ok(19, strtol("12", &end, 1) == 0 && end != 0 && *end == '1'
	   && strtol("12", &end, 37) == 0 && *end == '1');
#endif
	ok(20, strtol("123", (char **) 0, 10) == 123);
	errno = 0;
	ok(21, strtol("99", &end, 10) == 99 && errno == 0);

	if (sizeof(long) == 4) {
		errno = 0;
		ok(22, strtol("2147483647", &end, 10) == LONG_MAX
		   && errno == 0 && *end == 0);
		ok(23, strtol("2147483648", &end, 10) == LONG_MAX
		   && errno == ERANGE && *end == 0);
		errno = 0;
		ok(24, strtol("-2147483648", &end, 10) == LONG_MIN
		   && errno == 0);
		ok(25, strtol("-2147483649", &end, 10) == LONG_MIN
		   && errno == ERANGE);
		errno = 0;
		ok(26, strtoul("4294967295", &end, 10) == ULONG_MAX
		   && errno == 0);
		ok(27, strtoul("4294967296", &end, 10) == ULONG_MAX
		   && errno == ERANGE && *end == 0);
		errno = 0;
		ok(28, strtoul("-1", &end, 10) == ULONG_MAX && errno == 0);
		ok(29, strtol("99999999999999999999", &end, 16) == LONG_MAX
		   && *end == 0);
	}
	if (sizeof(int) == 2) {
		ok(30, atoi("-32768") == INT_MIN);
		ok(31, atoi("32767") == INT_MAX);
	}

	ok(32, abs(-5) == 5 && abs(5) == 5 && abs(0) == 0);
	ok(33, labs(-100000L) == 100000L && labs(7L) == 7L);
	if (sizeof(int) == 2)
		ok(34, abs(INT_MIN) == INT_MIN);
}

#ifdef __BCC__
/* only in libc */
void strings()
{
	ok(40, strcmp(itoa(0), "0") == 0);
	ok(41, strcmp(itoa(-1), "-1") == 0);
	ok(42, strcmp(itoa(32767), "32767") == 0);
	ok(43, strcmp(itoa(-32768), "-32768") == 0);	/* dev86: wrong */
	ok(44, strcmp(ltoa(0L), "0") == 0);
	ok(45, strcmp(ltoa(-100000L), "-100000") == 0);
	ok(46, strcmp(ltoa(LONG_MAX), "2147483647") == 0);
	ok(47, strcmp(ltoa(LONG_MIN), "-2147483648") == 0);
	ok(48, strcmp(ultoa(ULONG_MAX), "4294967295") == 0);
	ok(49, strcmp(ltostr(255L, 16), "ff") == 0);
	ok(50, strcmp(ltostr(-255L, 2), "-11111111") == 0);
	ok(51, strcmp(ultostr(ULONG_MAX, 36), "1z141z3") == 0);
	ok(52, ltostr(1L, 1) == 0 && ltostr(1L, 37) == 0);
}
#endif

int icmp(a, b)
int *a, *b;
{
	return *a < *b ? -1 : *a > *b;
}

struct rec {
	char key;
	long val;
	char pad;
};

int rcmp(a, b)
struct rec *a, *b;
{
	return a->key - b->key;
}

int sorted(a, n)
int *a, n;
{
	int i;

	for (i = 1; i < n; i++)
		if (a[i - 1] > a[i])
			return 0;
	return 1;
}

void sorting()
{
	static int a[] = { 5, -3, 9, 0, 9, 2, -32000, 31000, 1, 7, 3, 3, 8 };
	static int b[] = { 1 };
	static struct rec r[] = {
		{ 'm', 1L }, { 'c', 2L }, { 'x', 3L }, { 'a', 4L },
		{ 'q', 5L }, { 'b', 6L }, { 'z', 7L }
	};
	int n = sizeof(a) / sizeof(a[0]), i, key, *p;
	int c[50];
	struct rec k, *rp;

	qsort(a, n, sizeof(a[0]), icmp);
	ok(60, sorted(a, n));
	for (i = 0; i < n; i++)
		putnum(a[i]);
	qsort(b, 1, sizeof(b[0]), icmp);
	ok(61, b[0] == 1);
	qsort(b, 0, sizeof(b[0]), icmp);
	ok(62, b[0] == 1);

	/* already sorted, reversed, and equal */
	for (i = 0; i < 50; i++)
		c[i] = i;
	qsort(c, 50, sizeof(c[0]), icmp);
	ok(63, sorted(c, 50) && c[0] == 0 && c[49] == 49);
	for (i = 0; i < 50; i++)
		c[i] = 50 - i;
	qsort(c, 50, sizeof(c[0]), icmp);
	ok(64, sorted(c, 50) && c[0] == 1 && c[49] == 50);
	for (i = 0; i < 50; i++)
		c[i] = 4;
	qsort(c, 50, sizeof(c[0]), icmp);
	ok(65, c[0] == 4 && c[49] == 4);

	/* elements that aren't a power of two in size, with longs */
	qsort(r, 7, sizeof(r[0]), rcmp);
	for (i = 0; i < 7; i++)
		putchar(r[i].key);
	putchar('\n');
	ok(66, r[0].val == 4L && r[6].val == 7L && r[3].val == 1L);

	for (i = 0; i < n; i++) {
		key = a[i];
		p = (int *) bsearch(&key, a, n, sizeof(a[0]), icmp);
		ok(70 + i, p != 0 && *p == key);
	}
	key = 4;
	ok(90, bsearch(&key, a, n, sizeof(a[0]), icmp) == 0);
	key = -32001;
	ok(91, bsearch(&key, a, n, sizeof(a[0]), icmp) == 0);
	key = 1;
	ok(92, bsearch(&key, a, 0, sizeof(a[0]), icmp) == 0);
	k.key = 'q';
	rp = (struct rec *) bsearch(&k, r, 7, sizeof(r[0]), rcmp);
	ok(93, rp != 0 && rp->val == 5L);
}

void randoms()
{
	int i, x, first[5], good;

	srand(1);
	good = 1;
	for (i = 0; i < 5; i++) {
		first[i] = rand();
		if (first[i] < 0 || first[i] > RAND_MAX)
			good = 0;
	}
	ok(100, good);
	srand(1);
	for (i = 0; i < 5; i++)
		if (rand() != first[i])
			good = 0;
	ok(101, good);			/* the same seed, the same numbers */
#ifdef __BCC__
	/* the C standard's example generator, from seed 1 */
	ok(102, first[0] == 16838 && first[1] == 5758 && first[2] == 10113);
#endif
	srand(2);
	x = rand();
	ok(103, x != first[0]);
}

int main()
{
	classes();
	cases();
	numbers();
#ifdef __BCC__
	strings();
#endif
	sorting();
	randoms();
	say("checks ");
	putnum(checks);
	say("failures ");
	putnum(failures);
	return failures;
}
