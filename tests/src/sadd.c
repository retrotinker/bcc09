/* built by bcc09 -Mi (for sim6809): ints and signed chars added and
   subtracted, the char on either side, in memory or a register (cc1
   once added a signed char in memory as if it were unsigned: 10 + -1
   gave 265); must print the same as with the host's compiler */

#include <stdio.h>

signed char gc = -1;
unsigned char guc = 255;

unsigned char ucf(unsigned char v)
{
	return v;
}

signed char scf(signed char v)
{
	return v;
}

int main()
{
	int a = 10, r, i, t;
	signed char c = -1, d = -3, *p = &c;
	unsigned char uc = 255;

	printf("a + c %d\n", a + c);
	printf("c + a %d\n", c + a);
	printf("a - c %d\n", a - c);
	printf("c - a %d\n", c - a);
	printf("a + gc %d\n", a + gc);
	printf("a + *p %d\n", a + *p);
	printf("a + uc %d\n", a + uc);
	printf("a + guc %d\n", a + guc);
	r = a;
	r += c;
	printf("r += c %d\n", r);
	r = a;
	r -= c;
	printf("r -= c %d\n", r);
	r = a;
	r += gc;
	printf("r += gc %d\n", r);
	printf("c + c %d\n", c + c);
	printf("c + d %d\n", c + d);
	printf("c - d %d\n", c - d);
	printf("a + c + 1 %d\n", a + c + 1);
	printf("a * 2 + c %d\n", a * 2 + c);
	printf("(a + c) * (a - c) %d\n", (a + c) * (a - c));
	printf("a + ucf(200) %d\n", a + ucf(200));
	printf("ucf(200) + a %d\n", ucf(200) + a);
	printf("a + scf(-5) %d\n", a + scf(-5));
	printf("a - scf(-5) %d\n", a - scf(-5));
	printf("scf(-5) - a %d\n", scf(-5) - a);
	t = 0;
	for (i = 0; i < 100; i++)
		t += c + d - c;		/* (and the stack stays balanced) */
	printf("loop %d\n", t);
	return 0;
}
