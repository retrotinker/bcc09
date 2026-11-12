/* structret.c - functions that return structures (through a hidden
   pointer to the result, pushed after the arguments): with no arguments
   and with each kind of first argument (an int or a pointer in X, a char,
   a long in D and X, a double on the stack), of several sizes, through a
   function pointer, used straight away (a member, an argument, an
   assignment), nested, and in a first argument (which is evaluated after
   the others are pushed); structures as arguments, the first on the
   stack; it must print the same as with the host's compiler */

#include <stdio.h>

struct one { char c; };
struct two { int i; };
struct three { char a, b, c; };
struct pair { int quot, rem; };
struct big { long l; int i; char s[5]; };

struct pair divide(a, b)
int a, b;
{
	struct pair r;

	r.quot = a / b;
	r.rem = a % b;
	return r;
}

struct pair proto3(int a, int b, int c)
{
	struct pair r;

	r.quot = a + b;
	r.rem = b + c;
	return r;
}

struct pair none()
{
	struct pair r;

	r.quot = 7;
	r.rem = 8;
	return r;
}

struct one fromchar(c, n)
char c;
int n;
{
	struct one r;

	r.c = c + n;
	return r;
}

struct two fromlong(l, n)
long l;
int n;
{
	struct two r;

	r.i = (int) (l / 1000) + n;
	return r;
}

struct three fromdouble(d, n)
double d;
int n;
{
	struct three r;

	r.a = (char) d;
	r.b = (char) (d * 2);
	r.c = n;
	return r;
}

struct big makebig(i, s)
int i;
char *s;
{
	struct big r;
	int k;

	r.l = 100000L * i;
	r.i = -i;
	for (k = 0; k < 4 && s[k]; k++)
		r.s[k] = s[k];
	r.s[k] = 0;
	return r;
}

/* a struct-returning call in an argument, and one returned through */
int sum(p)
struct pair p;
{
	return p.quot * 100 + p.rem;
}

int sum2(p, n)
struct pair p;
int n;
{
	return p.quot * 100 + p.rem + n;
}

int sum3(n, p, m)
int n;
struct pair p;
int m;
{
	return n * 1000 + p.quot * 100 + p.rem * 10 + m;
}

/* a call whose first argument uses a structure a function returned: the
   structure must be gone from the stack before the call */
int both(a, b)
int a, b;
{
	return a * 10 + b;
}

int only(a)
int a;
{
	return a + 1000;
}

struct pair again(a, b)
int a, b;
{
	return divide(a, b);
}

int main()
{
	struct pair p, (*fp)();
	struct one o;
	struct two t;
	struct three th;
	struct big b;
	int x = 17, y = 5;

	p = divide(-7, 2);
	printf("divide %d %d\n", p.quot, p.rem);
	p = divide(x, y);
	printf("divide %d %d\n", p.quot, p.rem);
	p = proto3(1, 2, 3);
	printf("proto3 %d %d\n", p.quot, p.rem);
	p = none();
	printf("none %d %d\n", p.quot, p.rem);
	o = fromchar('A', 2);
	printf("fromchar %c\n", o.c);
	t = fromlong(123456L, 4);
	printf("fromlong %d\n", t.i);
	th = fromdouble(10.75, 9);
	printf("fromdouble %d %d %d\n", th.a, th.b, th.c);
	b = makebig(3, "wxyz!");
	printf("makebig %ld %d %s\n", b.l, b.i, b.s);
	fp = divide;
	p = (*fp)(100, 7);
	printf("pointer %d %d\n", p.quot, p.rem);
	printf("member %d %d\n", divide(50, 6).quot, divide(50, 6).rem);
	printf("argument %d %d %d\n", sum(divide(29, 4)), sum2(divide(29, 4), 5),
	       sum3(2, divide(29, 4), 7));
	p = again(1000, 33);
	printf("again %d %d\n", p.quot, p.rem);
	printf("nested %d\n", divide(divide(90, 4).quot, divide(9, 2).quot).rem);
	printf("first %d %d\n", both(divide(90, 4).quot, 4),
	       only(divide(9, 2).rem));
	return 0;
}
