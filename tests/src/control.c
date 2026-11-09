/* control flow: if, loops, switch, break, continue, goto, ?: and , */

int select(n)
int n;
{
	switch (n) {
	case 0:
		return 10;
	case 1:
	case 2:
		n += 5;
		break;
	case 7:
		n = -n;
		/* fall through */
	case 8:
		n *= 2;
		break;
	case 100:
		return 1;
	default:
		n = 0;
	}
	return n;
}

int loops(n)
int n;
{
	int i, j, t = 0;

	for (i = 0; i < n; i++) {
		if (i == 3)
			continue;
		if (i > 10)
			break;
		t += i;
	}
	while (t > 100)
		t -= 7;
	j = 0;
	do {
		j++;
	} while (j < n);
	for (;;) {
		if (--j <= 0)
			goto out;
	}
out:
	for (i = 0, j = n; i < j; i++, j--)
		t = t ? t + 1 : 1;
	return t;
}

/* a label reached by a goto before it and one after it: the second is a
   short branch back (cc1 once made it a JMP) */
int gotoloop(n)
int n;
{
	int i = 0, t = 0;

	goto again;
again:
	t += i;
	if (++i < n)
		goto again;
	return t;
}
