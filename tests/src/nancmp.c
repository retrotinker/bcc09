/* nancmp.c - comparisons with a NaN, which IEEE 754 makes all false but
   !=; bcc09's floating point compare helpers order a NaN above every
   other number instead (see BUGS: this records what they do) */

#include <stdio.h>

double zero = 0.0, one = 1.0, inf = 1.0e308 * 10.0;

void show(name, a, b)
char *name;
double a, b;
{
	printf("%-10s < %d  <= %d  > %d  >= %d  == %d  != %d\n", name,
	       a < b, a <= b, a > b, a >= b, a == b, a != b);
}

int main()
{
	double nan = zero / zero;

	show("nan 1", nan, one);
	show("1 nan", one, nan);
	show("nan inf", nan, inf);
	show("nan nan", nan, nan);
	return 0;
}
