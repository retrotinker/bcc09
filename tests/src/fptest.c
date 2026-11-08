/* run on sim6809: IEEE double and float arithmetic, comparisons, ++ and
   --, and conversions, through libc's floating point helpers and the
   compiler's code for them; checked against the tables in fpdata.h,
   which tests/gen-fpdata.py makes from Python's doubles, and exits with
   the number of failures */

#include "fpdata.h"

extern void putchar(), putnum();

/* results are compared, and printed, a word at a time, so that the
   checking doesn't depend on the helpers it checks */
union dw {
	double d;
	unsigned w[4];
};

union fw {
	float f;
	unsigned w[2];
};

int group;			/* which set of checks, for messages */
int index;			/* which check in the set */
int checks, failures;

void puts1(s)
char *s;
{
	while (*s)
		putchar(*s++);
}

/* a failed check prints its group and index, then the result and the
   expected value, a word at a time */
void fail(got, want, n)
unsigned *got, *want;
int n;
{
	int i;

	++failures;
	puts1("FAIL ");
	putnum(group);
	putnum(index);
	for (i = 0; i < n; i++)
		putnum(got[i]);
	for (i = 0; i < n; i++)
		putnum(want[i]);
	putchar('\n');
}

/* any NaN matches the NaN the tables have */
int isnanw(w, n)
unsigned *w;
int n;
{
	if (n == 4)
		return (w[0] & 0x7FF0) == 0x7FF0 &&
		    ((w[0] & 0xF) | w[1] | w[2] | w[3]);
	return (w[0] & 0x7F80) == 0x7F80 && ((w[0] & 0x7F) | w[1]);
}

void check(got, want, n)
unsigned *got, *want;
int n;
{
	int i;

	++checks;
	if (isnanw(want, n)) {
		if (!isnanw(got, n))
			fail(got, want, n);
		return;
	}
	for (i = 0; i < n; i++)
		if (got[i] != want[i]) {
			fail(got, want, n);
			return;
		}
}

void dcheck(d, want)
double d;
unsigned *want;
{
	union dw u;

	u.d = d;
	check(u.w, want, 4);
}

void fcheck(f, want)
double f;			/* (a float, promoted) */
unsigned *want;
{
	union fw u;

	u.f = f;
	check(u.w, want, 2);
}

void icheck(got, want)
long got, want;
{
	union dw g, w;

	g.w[0] = got >> 16;
	g.w[1] = got;
	w.w[0] = want >> 16;
	w.w[1] = want;
	check(g.w, w.w, 2);
}

/* the comparisons of a with b, as bits, against the expected order c */
void ccheck(a, b, c)
double a, b;
int c;
{
	unsigned got[1], want[1];

	got[0] = (a < b) | (a <= b) << 1 | (a == b) << 2 | (a != b) << 3 |
	    (a > b) << 4 | (a >= b) << 5;
	if (c == 2) {
		/* unordered: only == and != are as IEEE 754 says (see
		   libc/bcc/fpcmp.s) */
		got[0] &= 0xC;
		want[0] = 8;
	} else
		want[0] = (c < 0) | (c <= 0) << 1 | (c == 0) << 2 |
		    (c != 0) << 3 | (c > 0) << 4 | (c >= 0) << 5;
	check(got, want, 1);
}

void start(g)
int g;
{
	group = g;
	index = 0;
}

double zero = 0.0, mzero = -0.0;

void dpairs1()
{
	union dw a, b;
	unsigned *p;
	int i, j;

	/* the operands in memory (Faddd ...) */
	start(1);
	for (p = dpairs, i = 0; i < NPAIRS; i++, p += 25, index++) {
		for (j = 0; j < 4; j++) {
			a.w[j] = p[j];
			b.w[j] = p[4 + j];
		}
		dcheck(a.d + b.d, p + 8);
		dcheck(a.d - b.d, p + 12);
		dcheck(a.d * b.d, p + 16);
		dcheck(a.d / b.d, p + 20);
		ccheck(a.d, b.d, (int) p[24]);
	}
	/* both on the stack (Fadd ...): adding -0 changes nothing */
	start(2);
	for (p = dpairs, i = 0; i < NPAIRS; i++, p += 25, index++) {
		for (j = 0; j < 4; j++) {
			a.w[j] = p[j];
			b.w[j] = p[4 + j];
		}
		dcheck((a.d + mzero) + (b.d + mzero), p + 8);
		dcheck((a.d + mzero) - (b.d + mzero), p + 12);
		dcheck((a.d + mzero) * (b.d + mzero), p + 16);
		dcheck((a.d + mzero) / (b.d + mzero), p + 20);
	}
}

void fpairs1()
{
	union fw a, b;
	float r;
	unsigned *p;
	int i;

	start(3);
	for (p = fpairs, i = 0; i < NFPAIRS; i++, p += 12, index++) {
		a.w[0] = p[0];
		a.w[1] = p[1];
		b.w[0] = p[2];
		b.w[1] = p[3];
		r = a.f + b.f;
		fcheck(r, p + 4);
		r = a.f - b.f;
		fcheck(r, p + 6);
		r = a.f * b.f;
		fcheck(r, p + 8);
		r = a.f / b.f;
		fcheck(r, p + 10);
	}
}

void convs()
{
	union dw d;
	union fw f;
	float r;
	unsigned *p;
	int i, j;

	start(4);		/* double to float */
	for (p = dtoft, i = 0; i < NDTOF; i++, p += 6, index++) {
		for (j = 0; j < 4; j++)
			d.w[j] = p[j];
		r = d.d;
		fcheck(r, p + 4);
	}
	start(5);		/* float to double */
	for (p = ftodt, i = 0; i < NFTOD; i++, p += 6, index++) {
		f.w[0] = p[0];
		f.w[1] = p[1];
		dcheck(f.f, p + 2);
	}
	start(6);		/* doubles to integers */
	for (i = 0; i < NTOI; i++, index++) {
		for (j = 0; j < 4; j++)
			d.w[j] = toid[i * 4 + j];
		icheck((long) (int) d.d, (long) toiv[i]);
	}
	start(7);
	for (i = 0; i < NTOL; i++, index++) {
		for (j = 0; j < 4; j++)
			d.w[j] = told[i * 4 + j];
		icheck((long) d.d, tolv[i]);
	}
	start(8);
	for (i = 0; i < NTOUI; i++, index++) {
		for (j = 0; j < 4; j++)
			d.w[j] = touid[i * 4 + j];
		icheck((long) (unsigned) d.d, (long) touiv[i]);
	}
	start(9);
	for (i = 0; i < NTOUL; i++, index++) {
		for (j = 0; j < 4; j++)
			d.w[j] = tould[i * 4 + j];
		icheck((long) (unsigned long) d.d, (long) toulv[i]);
	}
	start(10);		/* integers to doubles */
	for (i = 0; i < NITOD; i++, index++)
		dcheck((double) itodv[i], itodd + i * 4);
	start(11);
	for (i = 0; i < NUITOD; i++, index++)
		dcheck((double) uitodv[i], uitodd + i * 4);
	start(12);
	for (i = 0; i < NLTOD; i++, index++)
		dcheck((double) ltodv[i], ltodd + i * 4);
	start(13);
	for (i = 0; i < NULTOD; i++, index++)
		dcheck((double) ultodv[i], ultodd + i * 4);
}

/* ++ and --, and chars and floats to and from doubles */
unsigned d2_5[] = { 0x4004, 0, 0, 0 };
unsigned d3_5[] = { 0x400C, 0, 0, 0 };
unsigned d1_5[] = { 0x3FF8, 0, 0, 0 };
unsigned dm1[] = { 0xBFF0, 0, 0, 0 };
unsigned f2_5[] = { 0x4020, 0 };
unsigned f1_5[] = { 0x3FC0, 0 };
unsigned f16m[] = { 0x4B80, 0 };	/* 16777216 */
unsigned d200[] = { 0x4069, 0, 0, 0 };
unsigned dm100[] = { 0xC059, 0, 0, 0 };

void others()
{
	double d, e;
	float f;
	unsigned char uc;
	signed char sc;
	char c;

	start(14);
	d = 2.5;
	e = d++;
	dcheck(e, d2_5);
	dcheck(d, d3_5);
	e = d--;
	dcheck(e, d3_5);
	dcheck(d, d2_5);
	e = ++d;
	dcheck(e, d3_5);
	dcheck(d, d3_5);
	e = --d;
	dcheck(e, d2_5);
	--d;
	dcheck(d, d1_5);
	f = 1.5;
	e = f++;
	dcheck(e, d1_5);
	fcheck(f, f2_5);
	--f;
	fcheck(f, f1_5);
	f = 16777216.0;
	f++;			/* 16777217 isn't a float: back to even */
	fcheck(f, f16m);
	d = -0.0;
	d--;
	dcheck(d, dm1);

	start(15);
	uc = 200;
	sc = -100;
	c = 200;
	dcheck((double) uc, d200);
	dcheck((double) sc, dm100);
	dcheck((double) c, d200);	/* char is unsigned */
	d = 200.75;
	uc = d;
	c = d;
	d = -100.5;
	sc = d;
	icheck((long) uc, 200L);
	icheck((long) c, 200L);
	icheck((long) sc, -100L);
}

int main()
{
	dpairs1();
	fpairs1();
	convs();
	others();
	puts1("checks ");
	putnum(checks);
	puts1(" failures ");
	putnum(failures);
	putchar('\n');
	return failures;
}
