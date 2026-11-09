/* built by bcc09 -Mi (for sim6809): the compiler's code for floats and
   doubles in many places (locals, arrays, structures, pointers, arguments
   in each position, with and without prototypes, results, conditions,
   compound assignments, conversions); prints integers made from the
   results, which must be the same with the host's compiler (but for the
   count of checks), and exits with the number of failed checks.  (Each
   argument here has its parameter's type, or is a float for a double:
   protoarg.c checks the conversion of other types.) */

#include <stdio.h>

int checks, failures;

void ok(int n, int cond)
{
	++checks;
	if (!cond) {
		++failures;
		printf("FAIL %d\n", n);
	}
}

/* x * 1000, rounded toward zero, as a long */
void p(char *what, double x)
{
	printf("%s %ld\n", what, (long) (x * 1000));
}

struct pt {
	char tag;
	double x;
	float y;
	int n;
};

double garr[4] = { 1.5, -2.25, 0.125, 1e6 };
float farr[3] = { 0.5, 3.0, -7.75 };
struct pt gpt = { 'a', 2.5, -1.5, 3 };
static double sd = 6.5;

/* old-style definitions: float parameters are doubles */
double kr1(a, b, c)
double a;
float b;
int c;
{
	return a * b + c;
}

float kr2(i, f)
int i;
double f;
{
	return i - f;
}

/* prototyped */
double pr1(double a, float b, long c);
float pr2(float a);
double pr3(int i, double d, char c, float f);
double fact(int n);
double sum3(double *v, int n);
double pass(double d);

double pr1(double a, float b, long c)
{
	return a / b - c;
}

float pr2(float a)
{
	return a * a;
}

double pr3(int i, double d, char c, float f)
{
	return i + d + c + f;
}

double fact(int n)
{
	return n <= 1 ? 1.0 : n * fact(n - 1);
}

double sum3(double *v, int n)
{
	double s = 0;

	while (n-- > 0)
		s += *v++;
	return s;
}

double pass(double d)
{
	return d;
}

void locals()
{
	double a = 1.25, b, arr[3];
	float f = 2.5f, g;
	int i;
	long l;
	unsigned u;
	unsigned long ul;
	unsigned char c;	/* (200 is out of a signed char's range) */
	signed char sc;
	struct pt s, *sp;
	double *dp;
	float *fp;

	b = a * 4;
	p("b", b);
	g = f / 4;
	p("g", g);
	arr[0] = a;
	arr[1] = b;
	arr[2] = arr[0] + arr[1];
	p("arr2", arr[2]);
	for (i = 0; i < 3; i++)
		arr[i] *= 2;
	p("arr", arr[0] + arr[1] + arr[2]);
	dp = arr;
	*dp += 1;
	dp[1] -= 0.5;
	p("dp", *dp + dp[1]);
	fp = farr;
	fp[2] /= 2;
	p("fp", fp[2]);
	s.tag = 'z';
	s.x = 3.75;
	s.y = s.x * 2;
	s.n = 9;
	sp = &s;
	sp->x += sp->y;
	p("s", sp->x + s.n);
	gpt.y *= -4;
	p("gpt", gpt.x * gpt.y + gpt.tag);
	ok(1, s.tag == 'z' && s.n == 9);

	/* conversions */
	i = 1000 * a;
	l = b * 100000;
	u = 40000.75;
	ul = 3.5e9;
	c = 200.9;
	sc = -100.9;
	printf("%d %ld %u %lu %d %d\n", i, l, u, ul, c, sc);
	a = i;
	p("i", a);
	a = l;
	p("l", a);
	a = u;
	p("u", a);
	a = ul;
	p("ul", a / 1000000);	/* (* 1000 must fit a long) */
	a = c;
	p("c", a);
	a = sc;
	p("sc", a);
	f = l;
	p("fl", f);
	l = f;
	printf("%ld\n", l);
	i = -2.5;
	l = -2.5;
	printf("%d %ld\n", i, l);
}

void conds()
{
	double z = 0, nz = -0.0, one = 1, two = 2;
	float fz = 0, f1 = 1;
	int n = 0;

	if (z)
		n += 1;
	if (!z)
		n += 2;
	if (nz)
		n += 4;
	if (one)
		n += 8;
	if (one && two)
		n += 16;
	if (z || one)
		n += 32;
	if (fz)
		n += 64;
	if (f1)
		n += 128;
	if (z == nz)
		n += 256;
	if (one < two && two > one && one <= one && two >= one && one != two)
		n += 512;
	if (one < 2 && 3 > two && one == 1)
		n += 1024;
	printf("conds %d\n", n);
	n = one > two ? 5 : 6;
	printf("%d %d %d\n", n, one == 1, z != 0);
	p("cond", one < two ? one : two);
	p("comma", (one += 1, one + two));
	n = 0;
	while (one < 100) {
		one *= 3;
		n++;
	}
	printf("while %d\n", n);
	for (one = 10; one > 0; one -= 2.5)
		n++;
	printf("for %d\n", n);
}

void calls()
{
	double d = 2.5;
	float f = 0.75;

	p("kr1", kr1(d, f, 3));
	p("kr2", kr2(7, d));
	p("pr1", pr1(10.0, 4.0, 2L));
	p("pr2", pr2(1.5));
	p("pr3", pr3(1, 2.5, 3, 4.25));
	p("fact", fact(10) / 1000);
	p("sum3", sum3(garr, 4));
	p("nest", pass(pass(d) * pass(f)) + pass(3.0));
	p("expr", kr1(1.0, 2.0, 1) * kr1(2.0, 1.0, 0) - pr2(2.0));
	p("args", pr3((int) d, f, 'A', d));
	p("sd", sd);
	ok(2, fact(5) == 120);
	ok(3, pr2(3.0) == 9.0f);
}

void incdec()
{
	double d = 1.5, arr[2];
	float f = -0.5;
	double *dp = arr;

	arr[0] = 10;
	arr[1] = 20;
	p("d++", d++);
	p("d", d);
	p("++d", ++d);
	p("d--", d--);
	p("--d", --d);
	p("f++", f++);
	p("--f", --f);
	(*dp)++;
	dp[1]--;
	++*dp;
	p("arr", arr[0] * 100 + arr[1]);
	p("dp++", *dp++);
	p("dp", *dp);
}

int main()
{
	printf("sizes %d %d\n", (int) sizeof(float), (int) sizeof(double));
	locals();
	conds();
	calls();
	incdec();
	printf("checks %d failures %d\n", checks, failures);
	return failures;
}
