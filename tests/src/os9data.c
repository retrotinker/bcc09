/* built with bcc09 -Mo (OS-9's data model: code position-independent,
   data through U) and run on sim6809 with simcrt0.s, which sets U to 0,
   so that the data is where the linker put it; calls only putnum and
   putchar (simcrt0.s) and libc's helpers, which keep U; checks globals,
   statics, strings, function pointers, double results (through __dret),
   ?: of doubles (on the stack), and float arguments; exits with the
   number of failed checks.  Its assembly (os9data-Mo.s) shows the code. */

extern void putchar(), putnum();

int checks, failures;
int g;
static int s = 5;
char buf[10];
char *str = 0;
long lg = 70000L;
double dg = 2.5;
int (*fp)();
static double sd;

void check(n, cond)
int n, cond;
{
	++checks;
	if (!cond) {
		++failures;
		putnum(n);
		putchar('\n');
	}
}

int twice(x)
int x;
{
	static int calls;	/* (a static local) */

	++calls;
	return x + x + calls - calls;
}

double half(d)
double d;
{
	return d / 2;
}

double pick(c, a, b)
int c;
double a, b;
{
	return c ? a : b;
}

double scale(f, i)
double f;		/* (a float argument comes as a double) */
int i;
{
	return f * i;
}

int main()
{
	char *p = "hello";
	static char lit[] = "abc";

	g = 3;
	buf[2] = 'x';
	str = p;
	check(1, g + s == 8 && buf[2] == 'x' && str[1] == 'e');
	check(2, lg + g == 70003L && lit[2] == 'c');
	fp = twice;
	check(3, fp(21) == 42 && (*fp)(s) == 10);
	sd = half(dg);
	check(4, sd == 1.25 && half(half(8.0)) == 2.0);
	check(5, pick(1, 1.5, 2.5) == 1.5 && pick(0, 1.5, 2.5) == 2.5);
	check(6, (g > 2 ? dg : sd) == 2.5 && scale((float) 1.5, 4) == 6.0);
	putnum(checks);
	putchar('\n');
	return failures;
}
