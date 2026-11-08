/* long and unsigned long operations, and conversions to and from int */

long l1 = 100000L, l2 = -5L, l3;
unsigned long ul = 0x80000000UL;
int i;

long lops(a, b)
long a, b;
{
	l3 = a + b;
	l3 = a - b;
	l3 = a * b;
	l3 = a / b;
	l3 = a % b;
	l3 = a & b;
	l3 = a | b;
	l3 = a ^ b;
	l3 = -a;
	l3 = ~a;
	l3 = a << 4;
	l3 = a >> 4;
	ul = ul >> 3;
	if (a < b) l3++;
	if (a == 0) l3--;
	return a * 3L;
}

int conv()
{
	l3 = i;
	i = l1;
	l3 = (unsigned)i;
	ul = 65536L * i;
	return (int)(l1 >> 16);
}
