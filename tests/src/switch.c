/* a switch dense enough to be compiled as a jump table */

int dense(n)
int n;
{
	switch (n) {
	case 1: return 11;
	case 2: return 22;
	case 3: return 33;
	case 4: return 44;
	case 5: return 55;
	case 6: return 66;
	}
	return -1;
}
