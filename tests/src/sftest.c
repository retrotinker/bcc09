/* built by bcc09 -Mi (for sim6809): the scanf family, over a grid of
   formats and inputs, and scanf reading stdin (sftest.in); it prints what
   each call returns and assigns, which must be the same with the host's
   C library (the values are chosen so that 16-bit and 32-bit ints agree);
   exits with the number of failed checks */

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

/* up to four ints */
void ti(fmt, in)
char *fmt, *in;
{
	int a = -99, b = -99, c = -99, d = -99, r;

	r = sscanf(in, fmt, &a, &b, &c, &d);
	printf("[%s] [%s] %d: %d %d %d %d\n", fmt, in, r, a, b, c, d);
}

/* longs */
void tl(fmt, in)
char *fmt, *in;
{
	long a = -99, b = -99;
	int r;

	r = sscanf(in, fmt, &a, &b);
	printf("[%s] [%s] %d: %ld %ld\n", fmt, in, r, a, b);
}

void tul(fmt, in)
char *fmt, *in;
{
	unsigned long a = 99, b = 99;
	int r;

	r = sscanf(in, fmt, &a, &b);
	printf("[%s] [%s] %d: %lu %lu\n", fmt, in, r, a, b);
}

/* shorts, and chars as numbers */
void th(fmt, in)
char *fmt, *in;
{
	short a = -99, b = -99;
	int r;

	r = sscanf(in, fmt, &a, &b);
	printf("[%s] [%s] %d: %d %d\n", fmt, in, r, a, b);
}

void thh(fmt, in)
char *fmt, *in;
{
	signed char a = -99;
	unsigned char b = 99;
	int r;

	r = sscanf(in, fmt, &a, &b);
	printf("[%s] [%s] %d: %d %d\n", fmt, in, r, a, b);
}

/* a string and an int for %n */
void tsn(fmt, in)
char *fmt, *in;
{
	char s[16];
	int n = -99, r;

	strcpy(s, "-----");
	r = sscanf(in, fmt, s, &n);
	printf("[%s] [%s] %d: [%s] %d\n", fmt, in, r, s, n);
}

/* strings (and an int for %n), and %c, whose characters aren't ended */
void tstr(fmt, in)
char *fmt, *in;
{
	char s1[16], s2[16];
	int n = -99, r;

	strcpy(s1, "-----");
	strcpy(s2, "-----");
	r = sscanf(in, fmt, s1, s2, &n);
	printf("[%s] [%s] %d: [%s] [%s] %d\n", fmt, in, r, s1, s2, n);
}

void numbers()
{
	/* d, i, x, o, u */
	ti("%d", "42");
	ti("%d", "-17");
	ti("%d", "+5");
	ti("%d", "  12abc");
	ti("%d", "abc");
	ti("%d", "");
	ti("%d", "   ");
	ti("%d", "-");
	ti("%d%d", "- 3");
	ti("%d", "32767");
	ti("%d", "-32768");
	ti("%d", "0");
	ti("%d%d", "007 8");
	ti("%i", "0x1f");
	ti("%i", "0X1F");
	ti("%i", "017");
	ti("%i", "0");
	ti("%i", "-0x10");
	ti("%i%n", "0x");
	ti("%i%d", "08");
	ti("%i%d", "09");
	ti("%i", "+077");
	ti("%x", "ff");
	ti("%x", "0xff");
	ti("%X", "FF");
	ti("%x%n", "0x");
	ti("%x%n", "0xg");
	ti("%x", "g");
	ti("%x", "-1a");
	ti("%o", "777");
	ti("%o%d", "78");
	ti("%o", "8");
	ti("%o", "-10");
	ti("%u", "123");
	ti("%u", "+65");

	/* widths */
	ti("%2d%d", "12345");
	ti("%3x%n", "0x1f");
	ti("%2i%d", "0x1f");
	ti("%3d%d", "-1234");
	ti("%1d%n", "-5");
	ti("%1d%d", "+5");
	ti("%4d%n", "  12");
	ti("%10d", "123");

	/* *, %n and what is in the format */
	ti("%d%n", "12 34");
	ti("%d %n%d", "12 34");
	ti("%*d%d", "1 2");
	ti("%*d%d", "5");
	ti("%*d%n", "5");
	ti("%*x%*o%d%n", "ff 17 9");
	ti("%d,%d", "1,2");
	ti("%d,%d", "1 ,2");
	ti("%d ,%d", "1 , 2");
	ti("%d , %d%n", "1,2");
	ti("x%d", "x5");
	ti("x%d", "y5");
	ti("x%d", " x5");
	ti(" x%d", " x5");
	ti("%d%%%d", "5% 6");
	ti("%d%%%d", "5 %6");
	ti("%d %% %d", "5%6");
	ti("%d%%", "5");
	ti("abc%d", "abc");
	ti("abc%d", "ab");
	ti("abc%n", "abcd");
	ti("", "");
	ti("", "abc");
	ti(" ", "");
	ti(" %n", "   x");
	ti("%n", "");
	ti("%n%d", "");
	ti("%d%n%d%n", "1 2");
	ti("%d%d%d%d", "1 2 3 4");
	ti("%d%d%d%d", "1 2 x 4");
	ti("%d\n%d", "1\n\t 2");
	ti("%d%d", "1\t\n\v\f\r 2");

	/* sizes */
	th("%hd", "-2");
	th("%hd", "70000");
	th("%hu", "-1");
	th("%hx%ho", "ffff 177777");
	th("%hi%hn", "-0x7fff");
	thh("%hhd%hhu", "300 255");
	thh("%hhd%hhu", "-1 -1");
	thh("%hhx%hhn", "1ff");
	thh("%hhi", "-0200");
	tl("%ld", "-100000");
	tl("%ld%ld", "2147483647 -2147483647");
	tul("%lx", "deadbeef");
	tul("%lX%lo", "0XCAFE 17777777777");
	tul("%lu", "4294967295");
	tl("%li%li", "0x7fffffff 0777");
	tl("%lld", "123456");
	tl("%ld%ln", "65536");
	tl("%5ld%ld", "1234567");
}

void strings()
{
	/* s */
	tstr("%s", "hello world");
	tstr("%s%s", "hello world");
	tsn("%s%n", "  hello  ");
	tstr("%3s%s", "abcdef");
	tstr("%s", "");
	tstr("%s", "   ");
	tstr("%s %s%n", "a\tb\nc");
	tstr("%*s%s", "skip this");

	/* c */
	tstr("%c", "x");
	tstr("%c%c", " y");
	tsn(" %c%n", "  z");
	tstr("%3c", "abcd");
	tstr("%3c%c", "abcd");
	tstr("%c", "");
	tstr("%3c", "ab");
	tstr("%*c%c", "pq");

	/* [ */
	tstr("%[a-z]", "abc123");
	tstr("%[a-z]%s", "abc123");
	tstr("%[^,],%[^,]", "foo,bar");
	tstr("%[^,],%[^,]", "foo,,bar");
	tstr("%[]a]%s", "]a]b");
	tstr("%[^]]%s", "x]y");
	tstr("%[a-]%s", "a-b");
	tstr("%[-a]%s", "-ab");
	tstr("%[0-9a-f]%s", "12fz");
	tstr("%2[a-z]%s", "abc");
	tstr("%[a-z]", "123");
	tstr("%[a-z]", "");
	tstr("%*[a-z]%s", "abc 12");
	tstr("%[ ]%s%n", "  x");
	tsn("%[^\n]%n", "a line\nnext");
	tstr("%[abc]%[cba]", "abba");
	tstr("%s%[ ]", "x");
}

void others()
{
	char buf[32];
	void *p;
	int a, b, r, n;

	/* %p reads what printf's %p writes */
	p = 0;
	r = sscanf("0x1234", "%p", &p);
	printf("%d %u\n", r, (unsigned) (unsigned long) p);
	sprintf(buf, "%p", (void *) 0x4321);
	r = sscanf(buf, "%p", &p);
	ok(1, r == 1 && p == (void *) 0x4321);

	/* sprintf and sscanf, back and forth */
	sprintf(buf, "%d %x %o %s", -1234, 0xbeef, 0644, "word");
	r = sscanf(buf, "%d %x %o %s%n", &a, &b, &n, buf + 20, &r);
	ok(2, a == -1234 && b == 0xbeef && n == 0644);
	ok(3, strcmp(buf + 20, "word") == 0);

	/* vsscanf through sscanf's string, which isn't changed */
	strcpy(buf, "7 8");
	a = b = 0;
	r = sscanf(buf, "%d%d", &a, &b);
	ok(4, r == 2 && a == 7 && b == 8 && strcmp(buf, "7 8") == 0);
}

/* scanf and getchar on stdin: what scanf doesn't use is left to read */
void input()
{
	char line[40];
	int v, w, x, r, c;

	while ((r = scanf("%d", &v)) == 1)
		printf("got %d\n", v);
	printf("stopped %d\n", r);
	c = getchar();
	printf("next [%c]\n", c);
	r = scanf("%d", &v);
	printf("%d %d\n", r, v);
	r = fscanf(stdin, " name: %[^\n]", line);
	printf("%d [%s]\n", r, line);
	r = scanf("%i%i%i", &v, &w, &x);
	printf("%d %d %d %d\n", r, v, w, x);
	r = scanf("%3d%d", &v, &w);
	printf("%d %d %d\n", r, v, w);
	c = getchar();
	printf("next %d\n", c);
	r = scanf("%d", &v);
	printf("%d %d\n", r, feof(stdin) != 0);
}

int main()
{
	numbers();
	strings();
	others();
	input();
	printf("checks %d failures %d\n", checks, failures);
	return failures;
}
