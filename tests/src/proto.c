/* ANSI prototypes and definitions, converted by unproto */

int add(int a, int b);
static long widen(int x);

int add(int a, int b)
{
	return a + b;
}

static long widen(int x)
{
	return (long)x << 8;
}

unsigned char clip(unsigned int v)
{
	return v > 255 ? 255 : (unsigned char)v;
}

int use(void)
{
	return add(clip(300), (int)widen(2));
}
