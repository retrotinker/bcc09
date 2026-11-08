/* calls: arguments, recursion, function pointers, static and register */

extern int ext_func();
extern int ext_var;

static int counter;

static int square(x)
int x;
{
	return x * x;
}

int fact(n)
int n;
{
	return n <= 1 ? 1 : n * fact(n - 1);
}

int apply(f, a)
int (*f)();
int a;
{
	return (*f)(a) + f(a + 1);
}

int many(a, b, c, d, e)
char a;
int b;
long c;
char *d;
int e;
{
	return a + b + (int)c + *d + e;
}

int next_id()
{
	static int id = 100;

	return id++;
}

int calls()
{
	register int r;
	int (*fp)() = square;

	counter++;
	r = apply(fp, 3);
	r += many('x', 2, 3L, "q", 5);
	r += ext_func(ext_var, counter);
	return r + fact(5) + next_id();
}
