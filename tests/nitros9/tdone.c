/* the last command of the nitros9 tests' startup script (see run.sh):
   reads $FF6A, an unused address in the CoCo 3's I/O page (which
   NitrOS-9 Level 2 maps into every process), on which XRoar traps to
   stop, so the tests needn't guess how long the programs take */

int sink;

int main()
{
	sink = *(unsigned char *) 0xFF6A;
	return 0;
}
