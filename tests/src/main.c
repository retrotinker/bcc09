/* the linked test program: start-up code, this, control.c and ptr.c */

extern int loops(), select(), ptrs();

int result[4];

int main()
{
	result[0] = loops(12);
	result[1] = select(7) + select(1);
	result[2] = ptrs();
	result[3] = result[0] + result[1] + result[2];
	return 0;
}
