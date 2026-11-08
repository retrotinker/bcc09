/* run on sim6809: call code from control.c, switch.c and ptr.c, check
   each result against the value the host compiler gives for the same
   source, and exit with the number of failures */

extern int select(), dense(), loops(), strlen1(), sum(), ptrs();
extern void copy(), putchar(), putnum();
extern int tab[];
extern char buf[];

int checks, failures;

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

	puts1("checks ");
	putnum(checks);
	puts1("failures ");
	putnum(failures);
	return failures;
}
