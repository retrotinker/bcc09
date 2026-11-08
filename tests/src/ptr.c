/* pointers, arrays, strings and pointer arithmetic */

char buf[16];
int tab[8] = { 1, 2, 3, 5, 8, 13, 21, 34 };
int grid[3][4];
char *msg = "hello, world";
char *msgs[] = { "one", "two", "three" };
int *ip = &tab[2];

int strlen1(s)
char *s;
{
	char *p = s;

	while (*p)
		p++;
	return p - s;
}

void copy(d, s)
char *d, *s;
{
	while ((*d++ = *s++) != 0)
		;
}

int sum(p, n)
int *p;
int n;
{
	int t = 0;

	while (n-- > 0)
		t += *p++;
	return t;
}

int ptrs()
{
	int *q = tab + 3;
	int **qq = &q;

	grid[1][2] = **qq;
	ip[1] = q[-1];
	copy(buf, msgs[2]);
	return q - tab + sum(tab, 8) + strlen1(msg) + grid[1][2] + buf[0];
}
