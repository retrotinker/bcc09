/* vecdp.c - __direct variables in a Vectrex cartridge (-Mv), run as
   vectest.c is: the program's DP is their page ($C8, where vectrex.ld
   puts the data), which Intensity_a(getdp()) shows, while the BIOS gets
   $D0 ($C8 for Init_Music_chk), and has it back after each call */

#include <vectrex.h>

__direct int n = 5;
__direct char tag[] = "DP";

int getdp()
{
	asm("tfr dp,a", "tfr a,b", "clra", "tfr d,x");
}

int main()
{
	Intensity_a(getdp());		/* C8 */
	Wait_Recal();
	Intensity_a(getdp());		/* C8 again */
	Moveto_d(n, tag[1]);		/* 05 'P' */
	Init_Music_chk(Music1);
	Intensity_a(getdp());		/* C8 */
	return 42;
}
