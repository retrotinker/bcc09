/* linked by bcc09 with the default crt0: the BSS must be cleared before
   main runs, and main's result goes back to the loader (loader.s) */

int zero;
char area[64];

int main()
{
	int i, bad;

	bad = 0;
	if (zero)
		bad++;
	for (i = 0; i < 64; i++)
		if (area[i])
			bad++;
	return bad ? 100 + bad : 42;
}
