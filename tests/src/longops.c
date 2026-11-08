/* run on sim6809: 32-bit long arithmetic, comparisons, shifts, unary
   operations, ++ and --, and conversions, through the run-time helpers
   in libc and the compiler's own code; checked against the tables in
   longdata.h, which tests/gen-longdata.py makes from a model of C with
   32-bit longs, and exits with the number of failures */

#include "longdata.h"

extern void putchar(), putnum();

/* results are compared, and printed, a word at a time, so that the
   checking doesn't depend on the helpers it checks */
union word2 {
	long l;
	unsigned w[2];
};

long *ep;			/* the next expected long */
int *iep;			/* the next expected int */
int group;			/* which set of checks, for messages */
int index;			/* which check in the set */
int checks, failures;

void puts1(s)
char *s;
{
	while (*s)
		putchar(*s++);
}

void fail(gh, gl, wh, wl)
unsigned gh, gl, wh, wl;
{
	++failures;
	puts1("FAIL ");
	putnum(group);
	putnum(index);
	putnum(gh);
	putnum(gl);
	putnum(wh);
	putnum(wl);
}

/* a failed check prints its group and index, then the result and the
   expected value, high word first */
void expect(got)
long got;
{
	union word2 g, w;

	g.l = got;
	w.l = *ep++;
	++checks;
	if (g.w[0] != w.w[0] || g.w[1] != w.w[1])
		fail(g.w[0], g.w[1], w.w[0], w.w[1]);
	++index;
}

void iexpect(got)
int got;
{
	++checks;
	if (got != *iep)
		fail(0, got, 0, *iep);
	++iep;
	++index;
}

void start(g, table)
int g;
long *table;
{
	group = g;
	index = 0;
	ep = table;
}

void istart(g, table)
int g;
int *table;
{
	group = g;
	index = 0;
	iep = table;
}

void pairs()
{
	int i, j, bits;
	long a, b;
	unsigned long ua, ub;

	start(1, ladd);
	for (i = 0; i < NV; i++)
		for (j = 0; j < NV; j++) {
			a = vals[i];
			b = vals[j];
			expect(a + b);
		}
	start(2, lsub);
	for (i = 0; i < NV; i++)
		for (j = 0; j < NV; j++) {
			a = vals[i];
			b = vals[j];
			expect(a - b);
		}
	start(3, land);
	for (i = 0; i < NV; i++)
		for (j = 0; j < NV; j++) {
			a = vals[i];
			b = vals[j];
			expect(a & b);
		}
	start(4, lor);
	for (i = 0; i < NV; i++)
		for (j = 0; j < NV; j++) {
			a = vals[i];
			b = vals[j];
			expect(a | b);
		}
	start(5, leor);
	for (i = 0; i < NV; i++)
		for (j = 0; j < NV; j++) {
			a = vals[i];
			b = vals[j];
			expect(a ^ b);
		}
	start(6, lmul);
	for (i = 0; i < NV; i++)
		for (j = 0; j < NV; j++) {
			a = vals[i];
			b = vals[j];
			expect(a * b);
		}
	start(7, lmul);
	for (i = 0; i < NV; i++)
		for (j = 0; j < NV; j++) {
			ua = vals[i];
			ub = vals[j];
			expect(ua * ub);
		}
	start(8, sdiv);
	for (i = 0; i < NV; i++)
		for (j = 0; j < NV; j++) {
			a = vals[i];
			b = vals[j];
			expect(a / b);
		}
	start(9, smod);
	for (i = 0; i < NV; i++)
		for (j = 0; j < NV; j++) {
			a = vals[i];
			b = vals[j];
			expect(a % b);
		}
	start(10, udiv);
	for (i = 0; i < NV; i++)
		for (j = 0; j < NV; j++) {
			ua = vals[i];
			ub = vals[j];
			expect(ua / ub);
		}
	start(11, umod);
	for (i = 0; i < NV; i++)
		for (j = 0; j < NV; j++) {
			ua = vals[i];
			ub = vals[j];
			expect(ua % ub);
		}
	istart(12, cmp);
	for (i = 0; i < NV; i++)
		for (j = 0; j < NV; j++) {
			a = ua = vals[i];
			b = ub = vals[j];
			bits = 0;
			if (a < b)
				bits |= 1;
			if (a <= b)
				bits |= 2;
			if (a > b)
				bits |= 4;
			if (a >= b)
				bits |= 8;
			if (a == b)
				bits |= 0x10;
			if (a != b)
				bits |= 0x20;
			if (ua < ub)
				bits |= 0x40;
			if (ua <= ub)
				bits |= 0x80;
			if (ua > ub)
				bits |= 0x100;
			if (ua >= ub)
				bits |= 0x200;
			iexpect(bits);
		}
}

void shifts()
{
	int i, j, n;
	long a;
	unsigned long ua;

	start(13, sshl);
	for (i = 0; i < NV; i++)
		for (j = 0; j < NC; j++) {
			a = vals[i];
			n = counts[j];
			expect(a << n);
		}
	start(14, sshl);
	for (i = 0; i < NV; i++)
		for (j = 0; j < NC; j++) {
			ua = vals[i];
			n = counts[j];
			expect(ua << n);
		}
	start(15, sshr);
	for (i = 0; i < NV; i++)
		for (j = 0; j < NC; j++) {
			a = vals[i];
			n = counts[j];
			expect(a >> n);
		}
	start(16, ushr);
	for (i = 0; i < NV; i++)
		for (j = 0; j < NC; j++) {
			ua = vals[i];
			n = counts[j];
			expect(ua >> n);
		}
}

/* by constants: partly the compiler's own code */
#define SHIFTC(c) expect(a << c); expect(a >> c); expect(ua >> c)

void constants()
{
	int i;
	long a;
	unsigned long ua;

	start(17, cshift);
	for (i = 0; i < NV; i++) {
		a = ua = vals[i];
		SHIFTC(1); SHIFTC(7); SHIFTC(8); SHIFTC(15);
		SHIFTC(16); SHIFTC(17); SHIFTC(24); SHIFTC(31);
	}
}

void unaries()
{
	int i;
	long a, b;
	unsigned u;

	start(18, unary);
	for (i = 0; i < NV; i++) {
		a = vals[i];
		expect(-a);
		expect(~a);
		b = a;
		b++;
		expect(b);
		b = a;
		--b;
		expect(b);
	}
	istart(19, tests);
	for (i = 0; i < NV; i++) {
		a = vals[i];
		iexpect(!a);
		iexpect((int)a);
	}
	start(20, widen);
	for (i = 0; i < NI; i++) {
		expect((long)ivals[i]);
		u = ivals[i];
		expect((long)u);
	}
}

int main()
{
	pairs();
	shifts();
	constants();
	unaries();
	puts1("checks ");
	putnum(checks);
	puts1("failures ");
	putnum(failures);
	return failures;
}
