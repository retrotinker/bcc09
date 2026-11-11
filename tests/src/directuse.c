/* directuse.c - uses dvar, declared extern __direct */
extern __direct int dvar;

int main()
{
	return dvar;
}
