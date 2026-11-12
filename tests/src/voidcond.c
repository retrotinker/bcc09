/* voidcond.c - conditional expressions of type void (as assert() is
   written: "e ? (void) 0 : f()"): each operand for what it does; it
   must print the same as with the host's compiler */

#include <stdio.h>

int count;

void bump(n)
int n;
{
	count += n;
}

int main()
{
	int i;

	for (i = 0; i < 6; i++) {
		i % 2 ? (void) 0 : bump(1);
		i > 3 ? bump(10) : (void) 0;
		i == 2 ? (void) bump(100) : (void) (count += 1000);
		(void) (i ? 0 : 1);
	}
	printf("count %d\n", count);
	return 0;
}
