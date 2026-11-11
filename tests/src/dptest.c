/* dptest.c - __direct variables at run time (-Mi): DP is their page, and
   each kind of variable and access gives what plain variables do, with
   -O too; printf() through the library; the number of failures is the
   exit status */

#include <stdio.h>

__direct int di = 1000;
__direct unsigned char dc;
__direct long dl = 100000L;
__direct int darr[5] = { 10, 20, 30, 40, 50 };
__direct struct pt { int x; char c; long l; } dpt;
__direct char *dp;
static __direct int dstat = 7;
char buf[4];
__direct char msg[] = "DP";
__direct char *dbuf = buf;
int fails;

int getdp()
{
	asm("tfr dp,a", "tfr a,b", "clra", "tfr d,x");
}

void check(what, got, want)
char *what;
long got, want;
{
	if (got != want) {
		printf("FAIL %s: %ld, not %ld\n", what, got, want);
		fails++;
	}
}

int counter()
{
	static __direct int n;

	return ++n;
}

int main()
{
	int i, *p;
	unsigned page = (unsigned)&di >> 8;

	check("DP", (long)getdp(), (long)page);
	check("&dc's page", (long)((unsigned)&dc >> 8), (long)page);
	check("&dpt's page", (long)((unsigned)&dpt >> 8), (long)page);
	check("di", (long)di, 1000L);
	check("dl", dl, 100000L);
	check("dstat", (long)dstat, 7L);
	check("msg[1]", (long)msg[1], (long)'P');
	check("&msg's page", (long)((unsigned)&msg >> 8), (long)page);
	check("dbuf", (long)(dbuf - buf), 0L);
	dc = 250;
	dc += 10;
	check("dc", (long)dc, 4L);
	di++;
	di *= 3;
	check("di++, *= 3", (long)di, 3003L);
	dl -= di;
	check("dl -= di", dl, 96997L);
	for (i = 0; i < 5; i++)
		darr[i] += i;
	check("darr[4]", (long)darr[4], 54L);
	check("darr[2] (constant)", (long)darr[2], 32L);
	p = &darr[1];
	*p = 99;
	check("darr[1] through a pointer", (long)darr[1], 99L);
	dpt.x = -5;
	dpt.c = 'q';
	dpt.l = dl + 3;
	check("dpt.x", (long)dpt.x, -5L);
	check("dpt.c", (long)dpt.c, (long)'q');
	check("dpt.l", dpt.l, 97000L);
	dp = buf;
	*dp++ = 'o';
	*dp++ = 'k';
	*dp = 0;
	check("dp", (long)(dp - buf), 2L);
	counter();
	counter();
	check("static in a function", (long)counter(), 3L);
	check("DP after", (long)getdp(), (long)page);
	printf("%s: di %d, dl %ld, darr %d %d %d %d %d, %d failures\n", buf,
	       di, dl, darr[0], darr[1], darr[2], darr[3], darr[4], fails);
	return fails;
}
