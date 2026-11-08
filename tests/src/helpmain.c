/* calls into the modules that need run-time helpers, so the linker
   loads them (it only loads modules that something refers to) */

extern long lops();
extern double fops();
extern int arith(), structs(), calls();

int main()
{
	lops(1L, 2L);
	fops(1.0, 2.0);
	arith(3, 4);
	structs();
	calls();
	return 0;
}
