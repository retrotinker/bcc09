/* directerr.c - __direct where it can't be: a function, a typedef, a
   parameter, an automatic or register variable; and in only some of a
   variable's declarations (either way round) */

__direct int f();
typedef __direct int dint;
extern __direct int mixed;
int mixed;
int other;
extern __direct int other;

int g(a)
__direct int a;
{
	__direct int autov;
	register __direct int regv;
	extern __direct int ok;

	return a + ok;
}
