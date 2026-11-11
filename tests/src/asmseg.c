/* assembly code outside a function may change the segment (a Vectrex
   header's loc 12, say): cc1 must then say LOC again before its next
   data or code, after #asm or asm(); asm inside a function leaves it as
   it was (the code there must put it back) */

int a = 1;
#asm
	loc	12
	fcb	8
#endasm
int b = 2;

int f()
{
	return a;
}

asm("loc 12", "fcb 9");

int g()
{
	asm("nop");
	return b;
}

char *s = "x";

char *h()
{
	asm("loc 0");
	return "y";
}
