/* run on sim6809: call code from control.c, switch.c, ptr.c and float.c, check
   each result against the value the host compiler gives for the same
   source, and exit with the number of failures */

extern int select(), dense(), loops(), strlen1(), sum(), ptrs();
extern void copy(), putchar(), putnum();
extern int tab[];
extern char buf[];
extern double fops(), d2;
extern int fconv();
extern float f1;

int checks, failures;
int one = 1;

/* a long as the second argument, which is passed on the stack */
long lsecond(d, l)
int d;
long l;
{
	return l;
}

/* a long result, with 3 bytes of the stack to pop on the way out (cc1
   once popped them into B and Y, losing the long's byte in B) */
long lodd(c)
char c;
{
	char k;

	k = c;
	return 100000L + k;
}

/* a long first argument (in D:X) to a function reached through a
   structure pointer, whose address needs an index register (cc1 once
   pushed the argument to free X, and called with X holding the address) */
long ldiff(a, b)
long a, b;
{
	return a - b;
}

struct lops {
	long (*f)();
} lops = { ldiff };

long lviaptr(p)
struct lops *p;
{
	return p->f(70000L, 5L) + p->f(1L, 2L);
}

void puts1(s)
char *s;
{
	while (*s)
		putchar(*s++);
}

/* a failed check prints its number, the result and the expected value */
void check(n, got, want)
int n, got, want;
{
	++checks;
	if (got != want) {
		++failures;
		puts1("FAIL ");
		putnum(n);
		putnum(got);
		putnum(want);
	}
}

int main()
{
	char tmp[8];

	/* switch, with fall through */
	check(1, select(0), 10);
	check(2, select(1), 6);
	check(3, select(2), 7);
	check(4, select(3), 0);
	check(5, select(7), -14);
	check(6, select(8), 16);
	check(7, select(100), 1);
	check(8, select(-1), 0);

	/* a switch compiled as a jump table, and both sides of its range */
	check(10, dense(0), -1);
	check(11, dense(1), 11);
	check(12, dense(2), 22);
	check(13, dense(3), 33);
	check(14, dense(4), 44);
	check(15, dense(5), 55);
	check(16, dense(6), 66);
	check(17, dense(7), -1);

	/* for, while, do, continue, break, goto, ?: and , */
	check(20, loops(0), 0);
	check(21, loops(1), 1);
	check(22, loops(3), 5);
	check(23, loops(4), 5);
	check(24, loops(5), 10);
	check(25, loops(12), 58);
	check(26, loops(20), 62);

	/* pointers, arrays and strings */
	check(30, strlen1("hello, world"), 12);
	copy(tmp, "abc");
	check(31, tmp[0], 'a');
	check(32, tmp[2], 'c');
	check(33, tmp[3], 0);
	check(34, sum(tab, 8), 87);
	check(35, sum(tab + 2, 3), 16);
	check(36, ptrs(), 221);
	check(37, buf[0], 't');
	check(38, strlen1(buf), 5);

	/* a long string, which copt -O once garbled (an overlapping
	   strcpy): every character, against one spelled out a character
	   at a time */
	{
		static char spelled[] = {
			'0','1','2','3','4','5','6','7','8','9','a','b','c','d',
			'e','f','0','1','2','3','4','5','6','7','8','9','A','B',
			'C','D','E','F', 0
		};
		char *lit = "0123456789abcdef0123456789ABCDEF";
		int i, same = 1;

		for (i = 0; i < 33; i++)
			if (lit[i] != spelled[i])
				same = 0;
		check(40, same, 1);
	}

	/* c ? 1L : 1 is a long, though both are small constants (cc1 once
	   made it a char) */
	check(41, lsecond(0, one ? 1L : 1) == 1L, 1);
	check(42, lsecond(0, one ? -1L : 1) == -1L, 1);
	check(43, lodd(2) == 100002L, 1);
	check(44, lviaptr(&lops) == 69994L, 1);

	/* doubles passed (on the stack) and returned (in D, X, Y and U),
	   and float and double globals */
	check(50, (int) (fops(3.5, 0.5) * 10), 70);
	check(51, (int) (d2 * 100), 700);
	check(52, (int) (fops(0.5, 2.0) * 10), 10);
	check(53, (int) (d2 * 100), -25);
	check(54, fconv(3), 6);
	check(55, (int) f1, 3);
	check(56, (int) d2, 3);
	check(57, fconv(-5), -11);
	check(58, (int) (f1 * 4), -20);

	puts1("checks ");
	putnum(checks);
	puts1("failures ");
	putnum(failures);
	return failures;
}
