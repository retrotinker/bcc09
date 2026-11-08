/* built by bcc09 -Mi: adding a signed char in memory to an int (see
   BUGS: cc1 adds it as if it were unsigned, so this prints 265, not 9) */

#include <stdio.h>

int main()
{
	int a = 10;
	signed char c = -1;

	printf("%d\n", a + c);
	return 0;
}
