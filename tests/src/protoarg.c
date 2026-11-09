/* built by bcc09 -Mi (for sim6809): arguments converted to the types of
   a prototype's parameters (cc1 has them from unproto's __proto): long,
   unsigned long, double, float, char, signed char, unsigned char, bool
   and pointer parameters given other types, first (in a register) and
   later; a definition that is its own prototype; a prototype in a block;
   a static function; the arguments after ...; libc's; and calls through
   function pointers (variables, typedefs, structure members, arrays,
   parameters, results and casts); prints the
   results, which must be the same with the host's compiler (but for the
   count of checks), and exits with the number of failed checks */

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <stdarg.h>

int checks, failures;

void ok(int n, int cond)
{
	++checks;
	if (!cond) {
		++failures;
		printf("FAIL %d\n", n);
	}
}

long lfirst(long a, int b);
long lsecond(int a, long b, int c);
unsigned long ulong1(unsigned long u);
double dfirst(double d, int i);
double dsecond(int i, double d);
double fparam(float f);
int cparam(char c, signed char s, unsigned char u);
int bparam(bool b, int i, bool c);
long mixed(char c, long l, double d, unsigned u);
int ptrparam(char *p, long n);
static long twice(long x);
int sum(int n, ...);

long lfirst(long a, int b)
{
	return a * 1000 + b;
}

long lsecond(int a, long b, int c)
{
	return a + b * 10 + c * 100;
}

unsigned long ulong1(unsigned long u)
{
	return u / 2;
}

double dfirst(double d, int i)
{
	return d * i;
}

double dsecond(int i, double d)
{
	return i + d;
}

double fparam(float f)
{
	return f * 2;
}

int cparam(char c, signed char s, unsigned char u)
{
	return c * 64 + s + u * 2;	/* (fits 16 bits) */
}

int bparam(bool b, int i, bool c)
{
	return b * 100 + i * 10 + c;
}

long mixed(char c, long l, double d, unsigned u)
{
	return c + l + (long) d + u;
}

int ptrparam(char *p, long n)
{
	return p == 0 ? (int) n : (int) n + *p;
}

static long twice(long x)
{
	return x + x;
}

int sum(int n, ...)
{
	va_list ap;
	int s = 0;

	va_start(ap, n);
	while (n-- > 0)
		s += va_arg(ap, int);
	va_end(ap);
	return s;
}

/* function pointers with prototypes */
typedef long (*lfn_t)(long);
struct ops {
	long (*m)(long a, int b);
	double (*d)(double);
} ops = { lfirst, 0 };
double (*dtab[2])(double d, int i) = { dfirst, 0 };

double halve(double d)
{
	return d / 2;
}

/* calls a callback with an int where it wants a long */
long callit(long (*cb)(long), int i)
{
	return cb(i);
}

lfn_t gettwice(int which)
{
	return which ? twice : (lfn_t) 0;
}

/* a definition that is its own prototype (nothing declared before it) */
long own(long a, double b)
{
	return a + (long) (b * 10);
}

int main()
{
	int i = 7;
	long l = 70000L;
	char c = 'A';
	double d = 2.5;
	unsigned u = 40000U;

	/* ints and constants where longs go */
	printf("%ld %ld %ld\n", lfirst(3, 4), lfirst(i, i), lfirst(-1, 0));
	printf("%ld %ld\n", lsecond(1, 2, 3), lsecond(i, 30000, i));
	printf("%lu %lu\n", ulong1(u), ulong1(65535U));
	printf("%ld %ld\n", twice(30000), own(5, 1));

	/* ints, longs and floats where doubles and floats go */
	printf("%g %g %g\n", dfirst(3, 4), dfirst(l, 2), dfirst(0.5, i));
	printf("%g %g\n", dsecond(1, 2), dsecond(i, l));
	printf("%g %g %g\n", fparam(3), fparam(l), fparam(d));

	/* wider values where chars go: cut down */
	printf("%d %d %d\n", cparam(65, -3, 300), cparam(c, 200, -1),
	       cparam(i, i, i));
	printf("%d %d %d\n", bparam(256, 1, 0.5), bparam(0, 2, l),
	       bparam(i, 3, 0));
	printf("%ld\n", mixed(321, i, 9, 7));

	/* a pointer, and 0 */
	printf("%d %d\n", ptrparam(0, 5), ptrparam("x", 1));

	/* after ..., only the usual promotions */
	printf("%d %d\n", sum(3, 1, 2, 3), sum(0));

	/* a prototype in a block */
	{
		long lfirst(long a, int b);

		printf("%ld\n", lfirst(i + 1, 2));
	}

	/* through function pointers */
	{
		long (*fp)(long, int) = lfirst;
		lfn_t tw = twice;
		struct ops *op = &ops;

		ops.d = halve;
		printf("%ld %ld %ld\n", fp(3, 4), (*fp)(i, 2), tw(30000));
		printf("%ld %g %g\n", op->m(5, 6), ops.d(7), op->d(l));
		printf("%g %ld %ld\n", dtab[0](3, 4), callit(twice, 20000),
		       gettwice(1)(25000));
		printf("%ld %ld\n", ((long (*)(long)) twice)(16000),
		       (i ? tw : twice)(17000));
	}

	/* libc's prototypes */
	printf("%ld %ld\n", labs(-5), labs(i - 10));
	printf("%d\n", (int) strlen("hello"));
	ok(1, labs(-30000) == 30000L);
	ok(2, lfirst(2, 0) == 2000L);
	printf("checks %d failures %d\n", checks, failures);
	return failures;
}
