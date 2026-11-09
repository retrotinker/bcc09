/* compiler errors: each line below is wrong */
int f(int a)
{
	int x = a +;
	undeclared = 3;
	return a
}

int g() { return f(1)) ; }

/* the wrong number of arguments for a prototype */
long two(long a, int b);
int vf(char *fmt, ...);
int h() { return two(1) + two(1, 2, 3) + vf() + vf("x", 1, 2); }
