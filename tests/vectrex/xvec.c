/* run as a Vectrex cartridge in MAME (see run.sh): built by bcc09 -Mv,
   whose start-up code copies the initialized data from the ROM to RAM
   and clears the BSS; draws a frame 100 times (text, a line, a dot, a
   vector list; and with the list, text and score functions: a pattern
   list, a rotated one, dots, a text list, the ships left, the score),
   and one more with Print_Str_hwyx and Mov_Draw_VLcs; checks the
   collision tests and Compare_Score on the real BIOS;
   reading the buttons and joystick and playing an explosion, after the
   BIOS's start screen (Select_Game(), left to end by itself); puts its
   checks in results[], which run.sh reads from RAM, and stops with
   status 42 */

#include <vectrex.h>

int count = 3;
char word[] = "INITIALIZED";
char bss[32];
signed char box[] = { 3, 0, 20, 20, 0, 0, -20, -20, 0 };
signed char shape[] = { 0, -10, -10, -1, 20, 0, -1, 0, 20,
			(signed char)0xAA, -20, 0, -1, 0, -20, 1 };
signed char arrow[] = { 0, 30 };	/* rotated a quarter turn each time */
signed char turned[2];
signed char dots[] = { 0, 0, 5, 5, 5, -5 };
char texts[] = { 90, -100, 'L', 'I', 'S', 'T', 0x80,
		 80, -100, 'O', 'F', ' ', 'T', 'W', 'O', 0x80, 0 };
char score[7];
char high[] = "   100\200";
char boom[] = { 0x19, 0x3F, 0x00, 0x02 };
char s500[] = "   500\200", s90[] = "    90\200";
char hw[] = { (char)0xF9, 0x48, 30, -40, 'H', 'W', 0x80 };
signed char mvlcs[] = { 1, 0x30, 7, 8, 9, 10, 11, 12 };
unsigned results[8];

int main()
{
	int i, clear = 1, snd, hwok;
	unsigned start;

	for (i = 0; i < sizeof bss; ++i)
		if (bss[i])
			clear = 0;
	Vec_Joy_Mux_1_X = 1;
	Vec_Joy_Mux_1_Y = 3;
	Vec_Joy_Mux_2_X = 0;
	Vec_Joy_Mux_2_Y = 0;
	Select_Game(2, 4);		/* nobody presses: 1 player, game 1 */
	Sound_Byte(7, 0x3E);
	snd = *(unsigned char *)0xC807 == 0x3E;	/* the BIOS's copy */
	Clear_Sound();			/* (the music buffer's mixer: off) */
	snd += 2 * (*(unsigned char *)0xC845 == 0x3F);
	Vec_Expl_Flag = 0x80;
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
		Reset0Ref();
		Moveto_d(40, 40);
		Draw_VLp(shape);
		Reset0Ref();
		Rot_VL_ab(16, 0, arrow, turned);
		Draw_VL_a(0, turned);
		Reset0Ref();
		Moveto_d(-80, 60);
		Dot_List(2, dots);
		Reset0Ref();
		Print_List(texts);
		Reset0Ref();
		Print_Ships(0x6E, 3, -110, -100);
		Read_Btns();
		Joy_Digital();
		Explosion_Snd(boom);
		Do_Sound();
	}
	Wait_Recal();			/* (the text and list, a frame) */
	Reset0Ref();
	Print_Str_hwyx(hw);
	hwok = Vec_Text_HW == 0xF948;
	Reset0Ref();
	Mov_Draw_VLcs(mvlcs);
	Clear_Score(score);
	Add_Score_a(25, score);
	Add_Score_d(0x1234, score);	/* 1259 */
	New_High_Score(score, high);
	results[0] = 0x6809;
	results[1] = count;
	results[2] = word[0];
	results[3] = clear;
	results[4] = Vec_Loop_Count - start;	/* 101 frames */
	/* Random()'s 1, the collision tests, Compare_Score, Print_Str_hwyx's
	   Vec_Text_HW: 0x3F (Mov_Draw_VLcs's scale can't be read back:
	   VIA_t1_cnt_lo reads the timer's count, not its latch) */
	results[5] = (Random() < 256)
	    + 2 * (Obj_Hit(10, 20, 14, 24, 5, 5) && !Obj_Hit(10, 20, 16, 20, 5, 5)
		   && Obj_Hit(10, 20, 4, 15, 6, 5) && !Obj_Hit(10, 20, 10, 26, 5, 5)
		   && Obj_Hit(120, 0, 127, 0, 10, 1))
	    + 4 * Obj_Will_Hit(10, 20, 6, 0, 16, 20, 5, 5)
	    + 8 * !Obj_Will_Hit(10, 20, -6, 0, 16, 20, 5, 5)
	    + 16 * (Compare_Score(s500, s90) == 1 && Compare_Score(s90, s500) == 2
		    && Compare_Score(s90, s90) == 0)
	    + 32 * hwok;
	results[6] = Vec_Joy_1_X + 0x100;	/* centred: 0x100 */
	results[7] = (score[2] == '1' && score[5] == '9')
	    + 2 * (high[2] == '1' && high[5] == '9')
	    + 4 * (turned[0] == 30 && turned[1] == 0)
	    + 8 * snd + 32 * (Vec_Expl_Flag < 0x80)	/* 3F */
	    + (Vec_Num_Players << 8) + (Vec_Num_Game << 12);	/* 113F */
	return 42;
}
