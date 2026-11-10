/* run as a Vectrex cartridge in MAME (see run.sh): built by bcc09 -Mv,
   whose start-up code copies the initialized data from the ROM to RAM
   and clears the BSS; draws a frame 100 times (text, a line, a dot, a
   vector list), reading the buttons and joystick; puts its checks in
   results[], which run.sh reads from RAM, and stops with status 42 */

#include <vectrex.h>

int count = 3;
char word[] = "INITIALIZED";
char bss[32];
signed char box[] = { 3, 0, 20, 20, 0, 0, -20, -20, 0 };
unsigned results[8];

int main()
{
	int i, clear = 1;
	unsigned start;

	for (i = 0; i < sizeof bss; ++i)
		if (bss[i])
			clear = 0;
	Vec_Joy_Mux_1_X = 1;
	Vec_Joy_Mux_1_Y = 3;
	Vec_Joy_Mux_2_X = 0;
	Vec_Joy_Mux_2_Y = 0;
	start = Vec_Loop_Count;
	for (i = 0; i < 100; ++i) {
		Wait_Recal();
		Intensity_a(0x7F);
		Print_Str_d(60, -70, "BCC09 VECTREX\200");
		Reset0Ref();
		VIA_t1_cnt_lo = 0x80;
		Moveto_d(-20, -40);
		Draw_Line_d(30, 80);
		Reset0Ref();
		Dot_d(-60, 0);
		Reset0Ref();
		Moveto_d(-40, -40);
		Draw_VLc(box);
		Read_Btns();
		Joy_Digital();
	}
	results[0] = 0x6809;
	results[1] = count;
	results[2] = word[0];
	results[3] = clear;
	results[4] = Vec_Loop_Count - start;	/* 100 frames */
	results[5] = Random() < 256;
	results[6] = Vec_Joy_1_X + 0x100;	/* centred: 0x100 */
	return 42;
}
