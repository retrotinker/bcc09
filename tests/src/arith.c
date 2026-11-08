/* char, int and unsigned arithmetic, shifts, comparisons and logic */

char c1 = 'A', c2;
unsigned char uc = 200;
int i1 = 1000, i2 = -7, i3;
unsigned u1 = 40000, u2;

int arith(a, b)
int a, b;
{
	i3 = a + b;
	i3 = a - b;
	i3 = a * b;
	i3 = a / b;
	i3 = a % b;
	i3 = -a;
	i3 = ~a;
	i3 = a & b;
	i3 = a | b;
	i3 = a ^ b;
	i3 = a << 3;
	i3 = a >> 2;
	i3 = a << b;
	i3 = a >> b;
	return a * 10 + b;
}

unsigned uarith(a, b)
unsigned a, b;
{
	u2 = a / b;
	u2 = a % b;
	u2 = a >> 1;
	u2 = a >> b;
	return a * b;
}

int chars()
{
	c2 = c1 + 1;
	c2 = uc >> 1;
	c2 = c1 * 3;
	return c1 + uc;
}

int compare(a, b)
int a, b;
{
	int n = 0;

	if (a == b) n++;
	if (a != b) n++;
	if (a < b) n++;
	if (a <= b) n++;
	if (a > b) n++;
	if (a >= b) n++;
	if (u1 < u2) n++;
	if (u1 > 30000) n++;
	if (a && b) n++;
	if (a || !b) n++;
	return n + (a < b ? a : b);
}

int incdec()
{
	int x = 5, y;

	y = x++;
	y = ++x;
	y = x--;
	y = --x;
	x += 3; x -= 2; x *= 4; x /= 2; x %= 7;
	x <<= 1; x >>= 1; x &= 0x0f; x |= 0x30; x ^= 0x11;
	return x + y;
}
