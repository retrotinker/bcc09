/* vectest.c - a Vectrex cartridge (bcc09 -Mv), linked with vectrex.ld
   (with S-record output) and run on sim6809 from its start-up code with
   vecbios.s, which prints each BIOS call (see run.sh): libvec.a's
   functions must pass their arguments in the BIOS's registers, with DP
   $D0 ($C8 for Init_Music_chk), and give back Read_Btns's and Random's
   results; the data must have been copied to RAM, and the BSS cleared */

#include <vectrex.h>

int count = 3;
char word[] = "INIT";
char bss[16];
signed char box[] = { 3, 0, 20, 20, 0, 0, -20, -20, 0 };

int main()
{
	int i, clear = 1;

	for (i = 0; i < sizeof bss; ++i)
		if (bss[i])
			clear = 0;
	Wait_Recal();
	Intensity_a(0x7F);
	Moveto_d(-20, 40);
	Draw_Line_d(30, -80);
	Dot_d(count, clear);		/* 3 and 1 */
	Reset0Ref();
	Print_Str_d(60, -70, "HELLO \200");
	Intensity_a(word[0]);		/* 'I': the data is in RAM */
	Draw_VLc(box);
	Intensity_a(Read_Btns());	/* $5A */
	Moveto_d(Random(), -1);		/* $33 */
	Joy_Digital();
	Init_Music_chk(Music1);
	Do_Sound();
	return 42;
}
