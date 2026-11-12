/* nancmp.c - comparisons with a NaN, which IEEE 754 makes all false but
   !=: doubles and floats, a NaN on either side, with numbers, infinity,
   another NaN and the constant 0 (the helpers' test against zero), and
   as conditions (if, !, ?:); it must print the same as with the host's
   compiler */

#include <stdio.h>

double zero = 0.0, one = 1.0, inf = 1.0e308 * 10.0;
float fzero = 0.0, fone = 1.0;

void show(name, a, b)
char *name;
double a, b;
{
	printf("%-10s < %d  <= %d  > %d  >= %d  == %d  != %d\n", name,
	       a < b, a <= b, a > b, a >= b, a == b, a != b);
}

void showf(name, a, b)
char *name;
float a, b;
{
	printf("%-10s < %d  <= %d  > %d  >= %d  == %d  != %d\n", name,
	       a < b, a <= b, a > b, a >= b, a == b, a != b);
}

int main()
{
	double nan = zero / zero;
	float fnan = fzero / fzero;

	show("nan 1", nan, one);
	show("1 nan", one, nan);
	show("nan -1", nan, -one);
	show("nan inf", nan, inf);
	show("-inf nan", -inf, nan);
	show("nan nan", nan, nan);
	show("1 2", one, one + one);
	show("2 1", one + one, one);
	show("1 1", one, one);
	showf("fnan 1", fnan, fone);
	showf("1 fnan", fone, fnan);
	showf("fnan fnan", fnan, fnan);
	printf("nan 0      < %d  <= %d  > %d  >= %d  == %d  != %d\n",
	       nan < 0.0, nan <= 0.0, nan > 0.0, nan >= 0.0, nan == 0.0,
	       nan != 0.0);
	printf("0 nan      < %d  <= %d  > %d  >= %d  == %d  != %d\n",
	       0.0 < nan, 0.0 <= nan, 0.0 > nan, 0.0 >= nan, 0.0 == nan,
	       0.0 != nan);
	printf("fnan 0     < %d  <= %d  > %d  >= %d  == %d  != %d\n",
	       fnan < 0.0, fnan <= 0.0, fnan > 0.0, fnan >= 0.0, fnan == 0.0,
	       fnan != 0.0);
	printf("if (nan) %d, !nan %d, nan > 1 ? %d, !(nan > 1) %d, "
	       "nan == nan %d\n", nan ? 1 : 0, !nan, nan > one ? 1 : 0,
	       !(nan > one), nan == nan);
	if (nan >= one || nan < one)
		printf("ordered (wrong)\n");
	else
		printf("unordered\n");
	return 0;
}
