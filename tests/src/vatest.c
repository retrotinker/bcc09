/* run on sim6809: variable argument lists with stdarg.h; prints results
   (which must be the same with the host's compiler and C library, built
   with tests/host/putnum.c) and exits with the number of failed checks */

#include <stdarg.h>

extern int putchar();
extern void putnum();

int checks, failures;

void say(s)
char *s;
{
	while (*s)
		putchar(*s++);
}

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

/* the last named parameter is the first (in a register) */
int sum(int n, ...)
{
	va_list ap;
	int t = 0;

	va_start(ap, n);
	while (n-- > 0)
		t += va_arg(ap, int);
	va_end(ap);
	return t;
}

long lsum(int n, ...)
{
	va_list ap;
	long t = 0;

	va_start(ap, n);
	while (n-- > 0)
		t += va_arg(ap, long);
	va_end(ap);
	return t;
}

/* the last named parameter isn't the first */
int two(int a, int b, ...)
{
	va_list ap;
	int t = a * 1000 + b * 100, x;

	va_start(ap, b);
	while ((x = va_arg(ap, int)) != 0)
		t += x;
	va_end(ap);
	return t;
}

/* a long first parameter (in D:X), and a char one */
long lfirst(long base, ...)
{
	va_list ap;
	int x;

	va_start(ap, base);
	while ((x = va_arg(ap, int)) != 0)
		base += x;
	va_end(ap);
	return base;
}

int cfirst(char c, ...)
{
	va_list ap;
	int t = c, x;

	va_start(ap, c);
	while ((x = va_arg(ap, int)) != 0)
		t = t * 2 + x;
	va_end(ap);
	return t;
}

/* a small printf: d (int), u (unsigned), l (long), s (string), c (char,
   which arrives as an int); each value on its own line */
void show(char *f, ...)
{
	va_list ap;
	char *s;

	va_start(ap, f);
	for (; *f; f++)
		switch (*f) {
		case 'd':
			putnum(va_arg(ap, int));
			break;
		case 'u':
			putnum((int) va_arg(ap, unsigned));
			break;
		case 'l':
			putlong(va_arg(ap, long));
			break;
		case 's':
			s = va_arg(ap, char *);
			say(s);
			putchar('\n');
			break;
		case 'c':
			putchar(va_arg(ap, int));
			putchar('\n');
			break;
		}
	va_end(ap);
}

/* a va_list handed on, as to vprintf */
int vsum(int n, va_list ap)
{
	int t = 0;

	while (n-- > 0)
		t += va_arg(ap, int);
	return t;
}

int handon(int n, ...)
{
	va_list ap;
	int t;

	va_start(ap, n);
	t = vsum(n, ap);
	va_end(ap);
	return t;
}

/* going through the arguments twice, with va_copy */
int twice(int n, ...)
{
	va_list ap, ap2;
	int t = 0, i;

	va_start(ap, n);
	va_copy(ap2, ap);
	for (i = 0; i < n; i++)
		t += va_arg(ap, int);
	for (i = 0; i < n; i++)
		t += 10 * va_arg(ap2, int);
	va_end(ap2);
	va_end(ap);
	return t;
}

/* recursion through a variable argument function */
int depth(int n, ...)
{
	va_list ap;
	int a, b;

	va_start(ap, n);
	a = va_arg(ap, int);
	b = va_arg(ap, int);
	va_end(ap);
	if (n == 0)
		return a + b;
	return depth(n - 1, a + 1, b * 2) + n;
}

int main()
{
	int (*fp)() = sum;
	long big = 100000L;

	putnum(sum(0));
	putnum(sum(1, 7));
	putnum(sum(3, 1, 2, 3));
	putnum(sum(12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12));
	putlong(lsum(3, 100000L, -1L, 2000000000L));
	putnum(two(1, 2, 3, 4, 0));
	putnum(two(5, 6, 0));
	putlong(lfirst(70000L, 1, 2, 3, 0));
	putnum(cfirst('A', 1, 2, 0));
	show("dulsc", -5, 40000U, big, "hello", 'x');	/* (40000 is a long with 16-bit int) */
	show("lldd", -1L, 2147483647L, 1, 2);
	show("");
	putnum(handon(4, 10, 20, 30, 40));
	putnum(twice(3, 1, 2, 3));
	putnum((*fp)(2, 300, 400));
	putnum(depth(3, 1, 1));

	ok(1, sum(3, 1, 2, 3) == 6);
	ok(2, lsum(2, 100000L, 100000L) == 200000L);
	ok(3, two(1, 2, 3, 0) == 1203);
	ok(4, lfirst(-1L, 1, 0) == 0L);
	ok(5, handon(2, 5, 6) == 11);
	ok(6, twice(2, 1, 1) == 22);
	say("checks ");
	putnum(checks);
	say("failures ");
	putnum(failures);
	return failures;
}
