/* run on sim6809: 16-bit multiply, divide, modulus and shifts, through
   the run-time helpers in libc (by variables) and the compiler's inline
   code (by constants), and memcpy and structure copies; checked against
   the tables in opsdata.h, which tests/gen-opsdata.py makes from a model
   of 16-bit C, and exits with the number of failures */

#include "opsdata.h"

extern void putchar(), putnum();
extern char *memcpy();

int *ep;			/* the next expected value */
int group;			/* which set of checks, for messages */
int index;			/* which check in the set */
int checks, failures;

void puts1(s)
char *s;
{
	while (*s)
		putchar(*s++);
}

/* a failed check prints its group and index, the result and the
   expected value */
void expect(got)
int got;
{
	++checks;
	if (got != *ep) {
		++failures;
		puts1("FAIL ");
		putnum(group);
		putnum(index);
		putnum(got);
		putnum(*ep);
	}
	++ep;
	++index;
}

void start(g, table)
int g;
int *table;
{
	group = g;
	index = 0;
	ep = table;
}

/* by variables: the helpers */
void pairs()
{
	int i, j, a, b;
	unsigned ua, ub;

	start(1, smul);
	for (i = 0; i < NV; i++)
		for (j = 0; j < NV; j++) {
			a = vals[i];
			b = vals[j];
			expect(a * b);
		}
	start(2, smul);
	for (i = 0; i < NV; i++)
		for (j = 0; j < NV; j++) {
			ua = vals[i];
			ub = vals[j];
			expect(ua * ub);
		}
	start(3, sdiv);
	for (i = 0; i < NV; i++)
		for (j = 0; j < NV; j++) {
			a = vals[i];
			b = vals[j];
			expect(a / b);
		}
	start(4, smod);
	for (i = 0; i < NV; i++)
		for (j = 0; j < NV; j++) {
			a = vals[i];
			b = vals[j];
			expect(a % b);
		}
	start(5, udiv);
	for (i = 0; i < NV; i++)
		for (j = 0; j < NV; j++) {
			ua = vals[i];
			ub = vals[j];
			expect(ua / ub);
		}
	start(6, umod);
	for (i = 0; i < NV; i++)
		for (j = 0; j < NV; j++) {
			ua = vals[i];
			ub = vals[j];
			expect(ua % ub);
		}
}

void shifts()
{
	int i, j, a, n;
	unsigned ua;

	start(7, sshl);
	for (i = 0; i < NV; i++)
		for (j = 0; j < NC; j++) {
			a = vals[i];
			n = counts[j];
			expect(a << n);
		}
	start(8, sshl);
	for (i = 0; i < NV; i++)
		for (j = 0; j < NC; j++) {
			ua = vals[i];
			n = counts[j];
			expect(ua << n);
		}
	start(9, sshr);
	for (i = 0; i < NV; i++)
		for (j = 0; j < NC; j++) {
			a = vals[i];
			n = counts[j];
			expect(a >> n);
		}
	start(10, ushr);
	for (i = 0; i < NV; i++)
		for (j = 0; j < NC; j++) {
			ua = vals[i];
			n = counts[j];
			expect(ua >> n);
		}
}

/* by constants: the compiler's own code, in the order of the tables */
#define DIVC(c)	expect(a / c); expect(a % c); expect(ua / c); expect(ua % c)
#define SHIFTC(c) expect(a << c); expect(a >> c); expect(ua >> c)

void constants()
{
	int i, a;
	unsigned ua;

	start(11, cdivmod);
	for (i = 0; i < NV; i++) {
		a = ua = vals[i];
		DIVC(1); DIVC(2); DIVC(4); DIVC(8); DIVC(256); DIVC(3); DIVC(10);
		DIVC(-1); DIVC(-2); DIVC(-4); DIVC(-8); DIVC(-256);
	}
	start(12, cmul);
	for (i = 0; i < NV; i++) {
		a = vals[i];
		expect(a * 0); expect(a * 1); expect(a * 2); expect(a * 3);
		expect(a * 4); expect(a * 10); expect(a * 256); expect(a * 257);
	}
	start(13, cshift);
	for (i = 0; i < NV; i++) {
		a = ua = vals[i];
		SHIFTC(0); SHIFTC(1); SHIFTC(3); SHIFTC(8); SHIFTC(15);
	}
}

/* memcpy, and structure copies, which use it */
struct odd {
	char c[7];
};

struct odd s1 = { { 1, 0, 3, 4, 5, 6, 9 } }, s2;	/* a 0 inside, and sum 28 */
char big[300], copy[300];
int one = 1;

void copies()
{
	int i, sum;

	group = 14;
	index = 0;
	s2 = s1;
	sum = 0;
	for (i = 0; i < 7; i++)
		sum += s2.c[i];
	ep = &one;		/* expect() compares with *ep */
	expect(sum == 28);
	for (i = 0; i < 300; i++)
		big[i] = i;
	ep = &one;
	expect(memcpy(copy, big, 300) == copy);
	sum = 0;
	for (i = 0; i < 300; i++)
		if (copy[i] == big[i])
			sum++;
	ep = &one;
	expect(sum == 300);
	copy[0] = 99;
	memcpy(copy, big, 0);
	ep = &one;
	expect(copy[0] == 99);
}

int main()
{
	pairs();
	shifts();
	constants();
	copies();
	puts1("checks ");
	putnum(checks);
	puts1("failures ");
	putnum(failures);
	return failures;
}
