/* direct.c - __direct variables (in the direct page, reached as <name):
   initialized and not, of each kind of type, at file scope and static in
   a function, and an extern; each kind of access: load, store, ++, op=,
   an element (a constant index, and a variable one), a member, through a
   pointer, & of one; a char array from a string, a pointer to a plain
   variable; and a plain global beside them */

__direct int dx;
__direct char dc = 5;
__direct int darr[4] = { 1, 2, 3, 4 };
__direct struct { int a; char b; } ds;
__direct char *dp;
__direct long dl = 70000L;
int plain;
__direct char dmsg[] = "DP";
__direct int *dpi = &plain;
extern __direct int dext;
static __direct int dstat;

int f(i)
int i;
{
	static __direct int loc;
	int *p;

	dx = 1;
	dc++;
	darr[2] = dx + dc;
	darr[i] = 7;
	ds.b = 3;
	ds.a += 4;
	p = &dx;
	*dp = 9;
	dl += dx;
	loc = dext + dstat + plain;
	p = darr;
	return loc + darr[3] + *p;
}
