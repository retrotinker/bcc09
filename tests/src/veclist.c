/* veclist.c - libvec.a's list, text and score functions, run as
   vectest.c is, with vecbios.s printing what each BIOS routine gets:
   counts, scales, patterns and lists as the routine reads them, the
   fixed intensities through Intensity_a, and DP $D0 for the BIOS, the
   program's own ($C8, for its __direct variable) back after each call;
   Rot_VL_ab's destination and Clear_Score's score come back, which the
   last Intensity_a() shows (07: both, and the __direct variable) */

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

int getdp()
{
	asm("tfr dp,a", "tfr a,b", "clra", "tfr d,x");
}

int main()
{
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
	Intensity_a(getdp());		/* C8: the program's DP after all */
	Intensity_a((rotated[0] == 0x77) + 2 * (score[5] == '0') + 4 * frames);
	return 0;
}
