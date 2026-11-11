/* dpret.c - __direct variables, built by bcc09 alone (-Ms) and run by
   dploader.s, which calls it with DP $5A: the start-up code must set DP
   to their page, and _exit() give the loader's back; 42 if all is well */

__direct int a = 40;
__direct char b;

int getdp()
{
	asm("tfr dp,a", "tfr a,b", "clra", "tfr d,x");
}

int main()
{
	b = 2;
	if (getdp() != (unsigned)&a >> 8)
		return 1;
	return a + b;
}
