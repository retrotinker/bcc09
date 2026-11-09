/* built by bcc09 -Mi (for sim6809): stdint.h's types, limits and
   constant macros, and stdbool.h's bool (cc1's _Bool) converting every
   way; prints what is the same with the host's compiler and C library
   (the exact-width types; but for the count of checks), and checks what
   is bcc09's own (intptr_t, intmax_t: 16 and 32 bits); exits with the
   number of failed checks */

#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

int checks, failures;

void ok(int n, int cond)
{
	++checks;
	if (!cond) {
		++failures;
		printf("FAIL %d\n", n);
	}
}

/* _Bool from a function's result, and in a structure */
bool isodd(int n)
{
	return n & 1 ? 7 : 0;	/* (7 becomes true, 1) */
}

bool fromlong(long l)
{
	return l;		/* (0x10000 is true) */
}

struct flags {
	bool a;
	char c;
	bool b;
};

bool gb = 42;			/* (1) */
bool gb2 = 0.25;		/* (1) */
bool gb3 = 0;
struct flags gf = { 3, 'x', 0 };

int main()
{
	bool b, *bp;
	int i;
	long l;
	double d;
	char *p = 0;
	struct flags f;
	bool arr[4];

	printf("%d %d %d %d %d %d\n", (int) sizeof(int8_t),
	       (int) sizeof(uint8_t), (int) sizeof(int16_t),
	       (int) sizeof(uint16_t), (int) sizeof(int32_t),
	       (int) sizeof(uint32_t));
	printf("%d %d %u\n", INT8_MIN, INT8_MAX, UINT8_MAX);
	printf("%d %d %u\n", INT16_MIN, INT16_MAX, UINT16_MAX);
	printf("%ld %ld %lu\n", (long) INT32_MIN, (long) INT32_MAX,
	       (unsigned long) UINT32_MAX);
	printf("%ld %lu %d\n", (long) INT32_C(100000),
	       (unsigned long) UINT32_C(4000000000), (int) INT16_C(-5));
	printf("%d %d\n", (int) sizeof(INT32_C(1)), (int) sizeof(UINT32_C(1)));
#if INT32_MAX > 65535 && UINT32_MAX == 0xFFFFFFFF && INT16_MIN < 0
	printf("#if ok\n");
#endif
	{
		int8_t s8 = -128;
		uint8_t u8 = 255;
		int16_t s16 = -32768;
		uint16_t u16 = 65535U;
		int32_t s32 = INT32_MIN;
		uint32_t u32 = UINT32_MAX;

		s8--;		/* (wraps) */
		u8++;
		printf("%d %d %d %u %ld %lu\n", s8, u8, s16, u16, (long) s32,
		       (unsigned long) u32);
	}

	/* bool: every conversion gives 0 or 1 */
	printf("%d %d %d %d\n", (int) sizeof(bool), true, false,
	       __bool_true_false_are_defined);
	b = 5;
	printf("%d", b);
	b = 0;
	printf(" %d", b);
	b = 256;
	printf(" %d", b);
	l = 65536L;
	b = l;
	printf(" %d", b);
	b = -1;
	printf(" %d", b);
	d = 0.001;
	b = d;
	printf(" %d", b);
	d = 0;
	b = d;
	printf(" %d", b);
	b = p;
	printf(" %d", b);
	b = &i;
	printf(" %d", b);
	b = (bool) 300;
	printf(" %d", b);
	i = 512;
	printf(" %d %d", (bool) i, (bool) (i - 512));
	printf(" %d %d %d\n", isodd(3), isodd(4), fromlong(0x10000L));

	/* compound assignment, ++ and -- */
	b = 1;
	b |= 4;
	printf("%d", b);
	b &= 2;
	printf(" %d", b);
	b ^= 6;
	printf(" %d", b);
	b ^= 1;
	printf(" %d", b);
	b += 2;
	printf(" %d", b);
	b -= 1;
	printf(" %d", b);
	b -= 1;
	printf(" %d", b);
	b *= 9;
	printf(" %d", b);
	b = 0;
	i = b++;
	printf(" %d %d", i, b);
	i = b++;
	printf(" %d %d", i, b);
	i = ++b;
	printf(" %d %d", i, b);
	i = b--;
	printf(" %d %d", i, b);
	i = b--;
	printf(" %d %d", i, b);
	i = --b;
	printf(" %d %d\n", i, b);

	/* in memory: a structure, an array, through a pointer, and globals */
	f.a = 2;
	f.c = 'q';
	f.b = 0.5;
	arr[0] = 7;
	arr[1] = arr[0] + arr[0];
	arr[2] = !arr[1];
	arr[3] = arr[1] == true;
	bp = &arr[2];
	*bp = 99;
	bp[1] += 10;
	(*bp)--;
	printf("%d %c %d %d %d %d %d\n", f.a, f.c, f.b, arr[0], arr[1],
	       arr[2], arr[3]);
	printf("%d %d %d %d %c %d\n", gb, gb2, gb3, gf.a, gf.c, gf.b);
	i = 0;
	for (b = true; b; b = false)
		i++;
	printf("%d %d %d\n", i, b ? 10 : 20, !b + 3 * b);

	/* bcc09's own sizes */
#ifdef __BCC__
	ok(1, sizeof(intptr_t) == 2 && sizeof(uintptr_t) == 2);
	ok(2, sizeof(intmax_t) == 4 && INTMAX_MAX == 2147483647L);
	ok(3, SIZE_MAX == 65535U && PTRDIFF_MAX == 32767);
	ok(4, sizeof(int_fast8_t) == 1 && sizeof(int_fast16_t) == 2);
#endif
	printf("checks %d failures %d\n", checks, failures);
	return failures;
}
