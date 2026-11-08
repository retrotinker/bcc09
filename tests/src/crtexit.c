/* linked by bcc09 with the default crt0: exit() from inside nested
   calls goes straight back to the loader (loader.s) with its status */

extern void exit();

void deep(n)
int n;
{
	if (n == 0)
		exit(7);
	deep(n - 1);
}

int main()
{
	deep(5);
	return 1;
}
