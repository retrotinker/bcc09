/* built by bcc09 -Mi (for sim6809): floating point in and out of text:
   printf's %e, %f, %g and %a over a grid of formats and values, strtod and
   atof over cases that round the hard way (halfway, at the ends of the
   range, many digits, hexadecimal), and sscanf's %f and friends; prints
   the results, which must be the same with the host's C library (but
   for the count of checks), and exits with the number of failed checks */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
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

/* a double from its bits (high byte first), whatever the host's order:
   NaNs with a known sign, which arithmetic doesn't give everywhere */
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

unsigned char inf[] = { 0x7f, 0xf0, 0, 0, 0, 0, 0, 0 };
unsigned char minf[] = { 0xff, 0xf0, 0, 0, 0, 0, 0, 0 };
unsigned char nan[] = { 0x7f, 0xf8, 0, 0, 0, 0, 0, 0 };
unsigned char mnan[] = { 0xff, 0xf8, 0, 0, 0, 0, 0, 0 };

double v[] = { 0.0, -0.0, 1.0, -1.5, 0.1, 0.5, 1.5, 2.5, 3.14159265358979,
	123456.789, 1e-5, 9.9999995e-5, 0.000123456, 1e10, 1e22, 1e100,
	-1e300, 1.7976931348623157e308, 2.2250738585072014e-308, 4.9e-324,
	999999.5, 0.95, 0.05, 1e15 + 0.3, 12345678901234567890.0,
	0.3333333333333333, 2.0 / 3, 0, 0, 0, 0,
	/* (for %a's rounding: 0x1.08p0, 0x1.18p0, 0x1.fffffffffffffp0, the
	   largest denormal, 1 + 2^-49 and 1 + 3 * 2^-49) */
	1.03125, 1.09375, 1.9999999999999998, 2.2250738585072009e-308,
	1.0000000000000017763568394002504646778106689453125,
	1.0000000000000053290705182007513940334320068359375
};

/* (not %#g: glibc prints 999999.5 as 1.e+06, where C says 1.00000e+06,
   as bcc09 prints it) */
char *fmts[] = { "%f", "%e", "%g", "%.0f", "%.0e", "%.0g", "%.1f", "%.3e",
	"%.10g", "%.17g", "%#.0f", "%#.8g", "%+.2e", "% f", "%12.4f",
	"%-12.3e|", "%012.3f", "%G", "%E", "%F", "%.20f", "%.30e", "%#.3g",
	"%-+8.1f|", "%08.2e", "%a", "%A", "%.0a", "%.1a", "%.3a", "%.12a",
	"%.15a", "%#a", "%#.0a", "%+.2a", "% a", "%25a", "%-25.4a|",
	"%025.2a", "%#A", 0
};

char *strs[] = { "0.1", "1e23", "8.98846567431158e307",
	"2.2250738585072011e-308", "2.2250738585072014e-308", "4.9e-324",
	"2.4703282292062327e-324", "2.4703282292062328e-324",
	"1.7976931348623157e308", "1.7976931348623158e308",
	"1.7976931348623159e308", "0x1.8p3", "0x.1p4", "-0", "inf",
	"-Infinity", "INFINITY", "  +12.5e-1xyz", ".5", "5.", ".", "e5", "1e",
	"1e+", "0x", "0x1p", "0xg", "123456789012345678901234567890",
	"0.1000000000000000055511151231257827021181583404541015625",
	"9007199254740993", "9007199254740995", "1e-400", "1e400",
	"0x1.fffffffffffff8p1023", "0x1p-1074", "0x1p-1075", "0x1.8p-1075",
	"0x1.0000000000001p-1022", "3.14159265358979323846264338327950288",
	"1.5", "-2.5e-3", "100", "1e-5", "123.456e2", "0.000001234",
	"4503599627370496.5", "4503599627370497.5", "1e308", "1e-307",
	"2e-323", "5e-324", "3e-324", "7.2057594037927933e16",
	"1.00000000000000011102230246251565404236316680908203125",
	"1.00000000000000011102230246251565404236316680908203124",
	"1.00000000000000011102230246251565404236316680908203126",
	"0.0000000000000000000000000000000000000000000000000000000000001",
	"00000000001.5", "1.5e00000000000000000003", "nan", "-nan(abc)",
	"nanq", 0
};

char *scans[] = { "1e", "1e+", "1e+x", "1ex", "0x", "0xg", "0x.p1", ".",
	".x", "-", "+.e1", "infin", "infx", "nanx", "nan(12", "nan(12)", "in",
	"0x1p", "1.5e3x", "  -2.5E-2", "1..2", "12345678901234567890123",
	"0x1.8p1", "-0", "3.25 4.5", 0
};

int main()
{
	int i, j, n, r;
	char *e;
	double d, d2;
	float f;
	char buf[64];

	v[27] = bits(inf);
	v[28] = bits(minf);
	v[29] = bits(nan);
	v[30] = bits(mnan);
	for (j = 0; fmts[j]; j++)
		for (i = 0; i < sizeof(v) / sizeof(v[0]); i++) {
			n = printf(fmts[j], v[i]);
			printf(" %d\n", n);
		}
	/* floats are passed as doubles; and through sprintf and snprintf */
	f = 0.1;
	printf("%.10f %g\n", f, f);
	n = sprintf(buf, "%8.3f|%-9.2e|%g", 3.14159, -0.000271828, 1e-10);
	printf("[%s] %d\n", buf, n);
	n = snprintf(buf, 8, "%f", 1234.5678);
	printf("[%s] %d\n", buf, n);
	printf("%d %s %5.1f %d\n", 42, "mixed", 2.25, -7);

	for (i = 0; strs[i]; i++) {
		errno = 0;
		d = strtod(strs[i], &e);
		printf("[%s] %.17g %d %d\n", strs[i], d, (int) (e - strs[i]),
		       errno == ERANGE);
	}
	printf("%.17g %.17g\n", atof("2.5"), atof("-1e-3x"));

	for (i = 0; scans[i]; i++) {
		f = -99;
		d = -99;
		n = -1;
		r = sscanf(scans[i], "%f%n", &f, &n);
		printf("[%s] %d %g %d", scans[i], r, f, n);
		n = -1;
		r = sscanf(scans[i], "%lf%n", &d, &n);
		printf(" | %d %.17g %d", r, d, n);
		n = -1;
		sscanf(scans[i], "%*e%n", &n);
		printf(" | %d\n", n);
	}
	r = sscanf("1.25 -3e2 0x10p-4 7", "%e %lg %la %3f", &f, &d, &d2, &f);
	printf("%d %g %g %g\n", r, d, d2, f);
	r = sscanf("12.5e1x", "%4lf%n", &d, &n);
	printf("%d %g %d\n", r, d, n);

	/* round trips: %.17g and %a of a double read back as the same
	   double */
	for (i = 0; i < sizeof(v) / sizeof(v[0]); i++) {
		if (i >= 27 && i <= 30)
			continue;
		sprintf(buf, "%.17g", v[i]);
		d = strtod(buf, &e);
		ok(i, d == v[i] && *e == '\0');
		sprintf(buf, "%a", v[i]);
		d = strtod(buf, &e);
		ok(100 + i, d == v[i] && *e == '\0');
	}
	printf("checks %d failures %d\n", checks, failures);
	return failures;
}
