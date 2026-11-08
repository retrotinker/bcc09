/* floating point (done in software) */

float f1 = 1.5;
double d1 = 2.25, d2;

double fops(a, b)
double a, b;
{
	d2 = a + b;
	d2 = a - b;
	d2 = a * b;
	d2 = a / b;
	if (a < b)
		d2 = -d2;
	return a * 2.0;
}

int fconv(i)
int i;
{
	f1 = i;
	d2 = f1;
	return (int)(d1 * i);
}
