/* splitprog.c - linked with split.ld: its initialized data, BSS and
   init functions (printf's and sscanf's floating point formats are each
   installed by one) are where the script put them */
#include <stdio.h>

int count = 3;
char buf[40];
double half = 0.5;

int main()
{
	float f;

	printf("count %d at %p, buf at %p\n", count, (void *)&count,
	       (void *)buf);
	if (sscanf("2.25", "%f", &f) == 1)
		printf("%g %g\n", half * count, f);
	return buf[0];
}
