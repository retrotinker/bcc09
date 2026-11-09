/* built by bcc09 -Mi (for sim6809): math.h's functions over special and
   ordinary arguments, each result printed exactly (%.17g) with errno;
   run.sh builds the same libc/math sources (Sun's fdlibm) on the host,
   with IEEE double arithmetic like bcc09's, where every result must be
   the same, bit for bit; and a few checks against known values (the
   count of checks isn't compared); exits with the number of failures */

#include <stdio.h>
#include <math.h>
#include <errno.h>

int checks, failures;

void ok(int n, int cond)
{
	++checks;
	if (!cond) {
		++failures;
		printf("FAIL %d\n", n);
	}
}

/* a NaN without its sign (the host's arithmetic gives -nan) */
void pr(double r)
{
	if (r != r)
		printf(" nan");
	else
		printf(" %.17g", r);
	if (errno)
		printf(errno == EDOM ? " EDOM" : errno == ERANGE ? " ERANGE" :
		       " errno");
	printf("\n");
}

/* an argument, a NaN without its sign */
void pa(char *fmt, double x)
{
	if (x != x)
		printf("nan");
	else
		printf(fmt, x);
}

/* a double from its bits (high byte first), whatever the host's order:
   a NaN with a known sign, which 0 / 0 doesn't give everywhere */
double bits(unsigned char *b)
{
	union {
		double d;
		unsigned char c[8];
	} u, one;
	int i, little;

	one.d = 1.0;
	little = one.c[0] == 0;
	for (i = 0; i < 8; i++)
		u.c[little ? 7 - i : i] = b[i];
	return u.d;
}

unsigned char nanbits[] = { 0x7f, 0xf8, 0, 0, 0, 0, 0, 0 };
double zero = 0.0;
double args[] = { 0.0, -0.0, 0.5, -0.5, 1.0, -1.0, 2.0, -2.0, 0.1,
	3.14159265358979, 1e-10, 1e10, 100.0, -100.0, 709.0, 710.0, -745.5,
	1e300, 4.9e-324, 2.2e-308, 0.75, 1.5, 6.2831853, 1e22, 12345.678,
	-0.999999, 0.999999, 1.0000001, 22.0, -30.0, 0.6931471805599453,
	2.302585092994046, 1e-300, 1e-5, 0, 0, 0
};

#define NARGS	(sizeof(args) / sizeof(args[0]))

struct f1 {
	char *name;
	double (*f)();
} f1s[] = {
	{ "acos", acos }, { "asin", asin }, { "atan", atan },
	{ "cos", cos }, { "sin", sin }, { "tan", tan },
	{ "cosh", cosh }, { "sinh", sinh }, { "tanh", tanh },
	{ "exp", exp }, { "log", log }, { "log10", log10 },
	{ "sqrt", sqrt }, { "ceil", ceil }, { "fabs", fabs },
	{ "floor", floor }, { "expm1", expm1 }, { 0, 0 }
};

double pairs[][2] = {
	{ 0, 0 }, { 1, 0 }, { 0, 1 }, { -1, 0 }, { 0, -1 }, { 1, 1 },
	{ -1, -1 }, { 2, 0.5 }, { 2, 10 }, { 2, -1 }, { 10, 400 }, { 10, -400 },
	{ 2, -1070 }, { -8, 3 }, { -8, 1.0 / 3 }, { -2, 0.5 }, { 0.5, 2.5 },
	{ 3.7, 1.2 }, { -3.7, 1.2 }, { 1e300, 3 }, { 1e-300, 7 },
	{ 123456.789, 0.001 }, { 1.5, 1e10 }, { 0.999, 1e5 }, { 7, -3.5 },
	{ 5.5, 1.75 }, { -5.5, 1.75 }, { 1e22, 3 }, { 1, 2 }, { -1, 2 },
	{ 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }
};

#define NPAIRS	(sizeof(pairs) / sizeof(pairs[0]))

int main()
{
	int i, j, e;
	double r, ip, inf, nan;

	inf = 1 / zero;
	nan = bits(nanbits);
	args[NARGS - 3] = inf;
	args[NARGS - 2] = -inf;
	args[NARGS - 1] = nan;
	pairs[NPAIRS - 4][0] = inf;
	pairs[NPAIRS - 4][1] = 2;
	pairs[NPAIRS - 3][0] = 2;
	pairs[NPAIRS - 3][1] = inf;
	pairs[NPAIRS - 2][0] = -inf;
	pairs[NPAIRS - 2][1] = -3;
	pairs[NPAIRS - 1][0] = nan;
	pairs[NPAIRS - 1][1] = 0;

	for (j = 0; f1s[j].name; j++)
		for (i = 0; i < NARGS; i++) {
			printf("%s(", f1s[j].name);
			pa("%.17g", args[i]);
			printf(")");
			errno = 0;
			pr((*f1s[j].f)(args[i]));
		}
	for (i = 0; i < NPAIRS; i++) {
		printf("pow(");
		pa("%g", pairs[i][0]);
		pa(", %g)", pairs[i][1]);
		errno = 0;
		pr(pow(pairs[i][0], pairs[i][1]));
		printf("atan2(");
		pa("%g", pairs[i][0]);
		pa(", %g)", pairs[i][1]);
		errno = 0;
		pr(atan2(pairs[i][0], pairs[i][1]));
		printf("fmod(");
		pa("%g", pairs[i][0]);
		pa(", %g)", pairs[i][1]);
		errno = 0;
		pr(fmod(pairs[i][0], pairs[i][1]));
	}
	for (i = 0; i < NARGS; i++) {
		errno = 0;
		r = frexp(args[i], &e);
		printf("frexp(");
		pa("%g", args[i]);
		printf(") %d", r == r && r != inf && r != -inf ? e : 0);
		pr(r);
		r = modf(args[i], &ip);
		printf("modf(");
		pa("%g", args[i]);
		printf(")");
		pr(r);
		printf(" ip");
		pr(ip);
	}
	for (i = -1080; i <= 1080; i += 135) {
		errno = 0;
		printf("ldexp(1.5, %d)", i);
		pr(ldexp(1.5, i));
	}
	errno = 0;
	printf("scalbn copysign");
	pr(scalbn(3.0, 4) + copysign(2.0, -0.0));
	printf("HUGE_VAL");
	pr(HUGE_VAL);

	/* some known values */
	ok(1, sqrt(2.0) * sqrt(2.0) - 2 < 1e-15);
	ok(2, pow(2.0, 10.0) == 1024.0);
	ok(3, exp(log(10.0)) - 10 < 1e-14);
	ok(4, sin(0.0) == 0 && cos(0.0) == 1);
	ok(5, floor(-2.5) == -3 && ceil(-2.5) == -2);
	ok(6, fabs(atan2(1.0, 1.0) * 4 - 3.141592653589793) < 1e-15);
	ok(7, sqrt(16.0) == 4 && sqrt(0.25) == 0.5);
	printf("checks %d failures %d\n", checks, failures);
	return failures;
}
