/* veclist.c - libvec.a's list, text, score, sound and input functions
   (and Select_Game), run as
   vectest.c is, with vecbios.s printing what each BIOS routine gets:
   counts, scales, patterns and lists as the routine reads them, the
   fixed intensities through Intensity_a, and DP $D0 for the BIOS, the
   program's own ($C8, for its __direct variable) back after each call;
   Rot_VL_ab's destination and Clear_Score's score come back, as do
   Read_Btns_Mask's mask (in Vec_Btn_State), Select_Game's choices and
   Joy_Analog's Vec_Misc_Count, which the next to last Intensity_a()
   shows (3F: all six); and the last (3F too) the scales lists2.s's
   functions set, Print_Str_hwyx's Vec_Text_HW, Compare_Score's results
   and Obj_Hit's and Obj_Will_Hit's, which vecbios.s does as the BIOS
   does */

#include <vectrex.h>

__direct int frames;
signed char vl[] = { 10, -10, 20, -20, 30, -30 };
signed char vlcs[] = { 1, 0x40, 5, 6, 7, 8 };
signed char vlp[] = { 0, 11, 12, -1, 13, 14, (signed char)0xAA, 15, 16, 1 };
signed char pts[] = { 1, 2, 3, 4 };
signed char rotated[4];
char strs[] = { 20, -30, 'O', 'N', 'E', 0x80, -20, -30, 'T', 'W', 'O', 0x80, 0 };
char one[] = { 5, 6, 'Y', 'X', 0x80 };
char score[7];
char high[] = "   100\200";
char regs[] = { 7, 0x38, 8, 0x0F, 0xFF };
char expl[] = { 0x19, 0x3F, 0x00, 0x02 };
signed char mvlc[] = { 2, 5, 6, 10, -10, 20, -20 };
signed char mvlcs[] = { 1, 0x30, 7, 8, 9, 10, 11, 12 };
signed char vlps[] = { 0x20, -1, 1, 2, 1 };
char hw[] = { (char)0xF9, 0x48, 30, -40, 'H', 'W', 0x80 };
char s500[] = "   500\200", s90[] = "    90\200";

int getdp()
{
	asm("tfr dp,a", "tfr a,b", "clra", "tfr d,x");
}

int main()
{
	int i, j;

	frames = 1;
	Intensity_1F();
	Intensity_3F();
	Intensity_5F();
	Intensity_7F();
	Moveto_d_7F(-5, 9);
	Draw_VL_a(2, vl);
	Mov_Draw_VL_a(2, vl);
	Draw_VLcs(vlcs);
	Draw_VLp(vlp);
	Draw_Pat_VL_a(1, 0xF0, vl);
	Dot_List(1, pts);
	Rot_VL_ab(16, 1, pts, rotated);
	Print_Str_yx(one);
	Print_List(strs);
	Print_Ships(0x66, 3, 0x10, -0x20);
	Clear_Score(score);
	Add_Score_a(25, score);
	Add_Score_d(0x1234, score);
	New_High_Score(score, high);
	Vec_Btn_State = 0xFF;
	Read_Btns_Mask(0x0C);
	Vec_Misc_Count = 0;
	Joy_Analog();
	Select_Game(2, 4);
	Sound_Byte(7, 0x3E);
	Sound_Bytes(regs);
	Clear_Sound();
	Explosion_Snd(expl);
	Mov_Draw_VLc_a(mvlc);
	Mov_Draw_VLcs(mvlcs);
	i = VIA_t1_cnt_lo == 0x30;
	Draw_VLp_FF(vlp);
	i += 2 * (VIA_t1_cnt_lo == 0xFF);
	Draw_VLp_7F(vlp);
	i += 4 * (VIA_t1_cnt_lo == 0x7F);
	Draw_VLp_scale(vlps);
	i += 8 * (VIA_t1_cnt_lo == 0x20);
	Print_Str_hwyx(hw);
	i += 16 * (Vec_Text_HW == 0xF948);
	i += 32 * (Compare_Score(s500, s90) == 1 &&
		   Compare_Score(s90, s500) == 2 && Compare_Score(s90, s90) == 0);
	j = Obj_Hit(10, 20, 14, 24, 5, 5) + 2 * !Obj_Hit(10, 20, 16, 20, 5, 5)
	    + 4 * Obj_Hit(10, 20, 4, 15, 6, 5) + 8 * !Obj_Hit(10, 20, 10, 26, 5, 5)
	    + 16 * Obj_Will_Hit(10, 20, 6, 0, 16, 20, 5, 5)
	    + 32 * Obj_Hit(120, 0, 127, 0, 10, 1);	/* (held at 127) */
	Intensity_a(getdp());		/* C8: the program's DP after all */
	Intensity_a((rotated[0] == 0x77) + 2 * (score[5] == '0') + 4 * frames
		    + 8 * (Vec_Btn_State == 0x0C) + 16 * (Vec_Misc_Count != 0)
		    + 32 * (Vec_Num_Players == 2 && Vec_Num_Game == 4));
	Intensity_a(i == 63 && j == 63 ? 0x3F : 0);
	Vec_Misc_Count = 0;
	return 0;
}
