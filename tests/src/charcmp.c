/* charcmp.c - comparisons of signed and unsigned chars, with constants
   (on either side) and with each other, in every relation: C compares
   them as ints, so a signed char of -1 is less than 0, 1 and 200, and
   than an unsigned char of 1; it must print the same as with the host's
   compiler (only explicit signed and unsigned chars, since a plain char
   is unsigned in bcc09 and signed on most hosts) */

#include <stdio.h>

signed char sv[] = { -128, -127, -2, -1, 0, 1, 2, 126, 127 };
unsigned char uv[] = { 0, 1, 2, 126, 127, 128, 200, 254, 255 };

#define N(a)	(sizeof(a) / sizeof(a[0]))

/* each relation of a with the constant k, then of k with a */
#define REL(a, k) \
	printf("%d%d%d%d%d%d%d%d%d%d%d%d ", (a) < k, (a) <= k, (a) > k, \
	       (a) >= k, (a) == k, (a) != k, k < (a), k <= (a), k > (a), \
	       k >= (a), k == (a), k != (a))

/* with every constant */
#define CONSTS(a) do { \
	REL(a, -129); REL(a, -128); REL(a, -2); REL(a, -1); REL(a, 0); \
	REL(a, 1); REL(a, 2); REL(a, 127); REL(a, 128); REL(a, 200); \
	REL(a, 255); REL(a, 256); \
} while (0)

/* each relation of two variables */
#define VARS(a, b) \
	printf("%d%d%d%d%d%d ", (a) < (b), (a) <= (b), (a) > (b), \
	       (a) >= (b), (a) == (b), (a) != (b))

int main()
{
	int i, j, checks = 0;
	signed char s, s2;
	unsigned char u, u2;
	int n;

	for (i = 0; i < N(sv); i++) {
		s = sv[i];
		printf("s %d: ", s);
		CONSTS(s);
		printf("\n");
		checks += 12 * 12;
	}
	for (i = 0; i < N(uv); i++) {
		u = uv[i];
		printf("u %d: ", u);
		CONSTS(u);
		printf("\n");
		checks += 12 * 12;
	}
	/* a char variable with another, and with an int */
	for (i = 0; i < N(sv); i++)
		for (j = 0; j < N(uv); j++) {
			s = sv[i];
			u = uv[j];
			s2 = sv[j];
			u2 = uv[i];
			n = uv[j] - 128;
			printf("%d %d: ", s, u);
			VARS(s, u);
			VARS(u, s);
			VARS(s, s2);
			VARS(u, u2);
			VARS(s, n);
			VARS(n, s);
			VARS(u, n);
			printf("\n");
			checks += 7 * 6;
		}
	/* through pointers too (a char in memory, not a register) */
	for (i = 0; i < N(sv); i++) {
		signed char *ps = &sv[i];
		unsigned char *pu = &uv[i];

		printf("*p %d %d: ", *ps, *pu);
		REL(*ps, 0);
		REL(*ps, 100);
		REL(*ps, 200);
		REL(*pu, 0);
		REL(*pu, 200);
		VARS(*ps, *pu);
		VARS(*pu, *ps);
		printf("\n");
		checks += 5 * 12 + 2 * 6;
	}
	printf("checks %d\n", checks);
	return 0;
}
