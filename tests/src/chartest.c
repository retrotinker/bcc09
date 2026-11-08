/* built by bcc09 -Mi (for sim6809): chars passed to and returned from
   functions with ANSI prototypes (cc1 once returned a char in the wrong
   byte, and took it back with a TFR between registers of different
   sizes); prints results, which must be the same with the host's
   compiler (plain char is unsigned in bcc09 and signed on most hosts,
   so the portable checks say which), and exits with the number of
   failed checks */

#include <stdio.h>

int checks, failures;

void ok(int n, int cond)
{
	++checks;
	if (!cond) {
		++failures;
		printf("FAIL %d\n", n);
	}
}

unsigned char uc_low(unsigned int v)
{
	return (unsigned char) v;
}

signed char sc_low(int v)
{
	return (signed char) v;
}

unsigned char uc_clip(unsigned int v)
{
	return v > 255 ? 255 : (unsigned char) v;
}

unsigned char uc_add(unsigned char a, unsigned char b)
{
	return a + b;			/* (wraps at 256) */
}

signed char sc_neg(signed char c)
{
	return -c;
}

int widen(unsigned char a, signed char b)
{
	return a * 100 + b;
}

/* a char as the second argument, on the stack */
int second(int a, unsigned char b, signed char c)
{
	return a + b * 2 + c;
}

unsigned char uc_rec(unsigned char n)
{
	return n == 0 ? 0 : uc_rec(n - 1) + 2;
}

unsigned char (*ucp)(unsigned int) = uc_low;

#ifdef __BCC__
char c_low(int v)
{
	return (char) v;
}
#endif

int main()
{
	unsigned char u;
	signed char s;

	printf("%d %d %d %d\n", uc_low(0x1234), uc_low(300), uc_low(255),
	       uc_low(0));
	printf("%d %d %d %d\n", sc_low(0x1234), sc_low(200), sc_low(-1),
	       sc_low(127));
	printf("%d %d %d\n", uc_clip(300), uc_clip(77), uc_clip(256));
	printf("%d %d\n", uc_add(200, 100), uc_add(1, 2));
	printf("%d %d %d\n", sc_neg(5), sc_neg(-128), sc_neg(0));
	printf("%d %d\n", widen(uc_low(250), sc_low(-3)),
	       widen(uc_add(255, 1), sc_neg(7)));
	printf("%d %d\n", second(10, uc_low(0x1ff), sc_low(-1)),
	       second(uc_clip(9), 200, -100));
	printf("%d %d\n", uc_rec(10), uc_rec(200));
	printf("%d\n", (*ucp)(0x4142));

	/* in expressions, and stored */
	u = uc_low(0x81);
	s = sc_low(0x81);
	printf("%d %d %d\n", u, s, uc_low(3) + sc_low(-5) * 2);
	ok(1, u == 0x81 && s == -127);
	ok(2, uc_low(0x1234) == 0x34 && sc_low(0xff) == -1);
	ok(3, uc_add(uc_low(250), uc_low(10)) == 4);
#ifdef __BCC__
	ok(4, c_low(0x1fe) == 0xfe);	/* plain char: unsigned in bcc09 */
#endif
	printf("checks %d failures %d\n", checks, failures);
	return failures;
}
