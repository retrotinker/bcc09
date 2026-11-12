; stands in for the Vectrex's BIOS on sim6809, for testing bcc09 -Mv's
; libvec.a: at $F000, each routine libvec.a calls is at its
; address, and prints its name, the registers it takes (A, B, U...) and
; DP through the simulator's I/O block; Read_Btns gives $5A and Random
; $33, for the program to pass on.  The fixed intensities and
; Print_Str_yx fall into Intensity_a and Print_Str_d, as the BIOS's do;
; the list routines print the list as they would read it; Rot_VL_ab
; writes $77 at U, Clear_Score "     0", for the program to check.
; Read_Btns_Mask and Joy_Analog do what the BIOS's do before falling into
; Read_Btns and Joy_Digital (Vec_Btn_State &= A; Vec_Misc_Count less 1);
; Select_Game chooses its A players and game B, Explosion_Snd prints its
; parameters (and DP: $C8)
;
; (After an ORG, as09's labels are absolute, though the bytes are placed
; from the segment's start: so it is linked at 0, and run.sh keeps only
; its S-records from $F000 up, past the zeros before the first ORG.)

IO_OUT	equ	$FF00
MISCCNT	equ	$C823		; Vec_Misc_Count
PATTERN	equ	$C829		; Vec_Pattern

	.text
	entry	bios		; (ld09 needs one; it isn't run)
bios:
	org	$F192
	jmp	s_wait		; $F192 Wait_Recal
	org	$F1B4
	anda	$C80F		; $F1B4 Read_Btns_Mask (into Read_Btns)
	sta	$C80F
	jmp	s_btns		; $F1BA Read_Btns
	org	$F1F5
	dec	MISCCNT		; $F1F5 Joy_Analog (into Joy_Digital)
	jmp	s_joy		; $F1F8 Joy_Digital
	org	$F256
	jmp	s_sbyte		; $F256 Sound_Byte
	org	$F272
	jmp	s_clrsn		; $F272 Clear_Sound
	org	$F27D
	jmp	s_sbyts		; $F27D Sound_Bytes
	org	$F289
	jmp	s_sound		; $F289 Do_Sound
	org	$F29D
	lda	#$1F		; $F29D Intensity_1F (into Intensity_a)
	bra	$F2AB
	lda	#$3F		; $F2A1 Intensity_3F
	bra	$F2AB
	lda	#$5F		; $F2A5 Intensity_5F
	bra	$F2AB
	lda	#$7F		; $F2A9 Intensity_7F
	jmp	s_inten		; $F2AB Intensity_a
	org	$F2C3
	jmp	s_dot		; $F2C3 Dot_d
	org	$F2D5
	jmp	s_dotl		; $F2D5 Dot_List
	org	$F2FC
	jmp	s_move7		; $F2FC Moveto_d_7F
	org	$F312
	jmp	s_move		; $F312 Moveto_d
	org	$F354
	jmp	s_reset		; $F354 Reset0Ref
	org	$F373
	ldd	,u++		; $F373 Print_Str_hwyx (into Print_Str_yx)
	std	$C82A		; (Vec_Text_HW)
	ldd	,u++		; $F378 Print_Str_yx (into Print_Str_d)
	jmp	s_print		; $F37A Print_Str_d
	org	$F38A
	jmp	s_plist		; $F38A Print_List
	org	$F393
	jmp	s_ships		; $F393 Print_Ships
	org	$F3AD
	lda	,x+		; $F3AD Mov_Draw_VLc_a (into Mov_Draw_VL_a)
	bra	$F3B9
	org	$F3B5
	ldd	,x++		; $F3B5 Mov_Draw_VLcs (the scale, then into
	stb	<$04		; Mov_Draw_VL_a)
	jmp	s_movdr		; $F3B9 Mov_Draw_VL_a
	org	$F3CE
	jmp	s_vlc		; $F3CE Draw_VLc
	org	$F3D6
	jmp	s_vlcs		; $F3D6 Draw_VLcs
	org	$F3DA
	jmp	s_vla		; $F3DA Draw_VL_a
	org	$F3DF
	jmp	s_line		; $F3DF Draw_Line_d
	org	$F404
	ldb	#$FF		; $F404 Draw_VLp_FF
	bra	$F40E
	ldb	#$7F		; $F408 Draw_VLp_7F
	bra	$F40E
	ldb	,x+		; $F40C Draw_VLp_scale
	stb	<$04		; (the scale, into Draw_VLp)
	jmp	s_vlp		; $F410 Draw_VLp
	org	$F434
	jmp	s_pat		; $F434 Draw_Pat_VL_a
	org	$F517
	jmp	s_rand		; $F517 Random
	org	$F610
	jmp	s_rot		; $F610 Rot_VL_ab
	org	$F687
	jmp	s_music		; $F687 Init_Music_chk
	org	$F7A9
	jmp	s_selg		; $F7A9 Select_Game
	org	$F84F
	jmp	s_clrsc		; $F84F Clear_Score
	org	$F85E
	jmp	s_addsa		; $F85E Add_Score_a
	org	$F87C
	jmp	s_addsd		; $F87C Add_Score_d
	org	$F8C7		; $F8C7 Compare_Score, as the BIOS's: A 0
	pshs	x,u		; the same, 1 X's higher, 2 U's
	clra
cs1:	ldb	,x+
	bmi	cs2
	cmpb	,u+
	beq	cs1
	bhi	cs3
	inca
cs3:	inca
cs2:	puls	x,u,pc
	org	$F8D8
	jmp	s_hisc		; $F8D8 New_High_Score
	org	$F8E5		; the collision tests, as the BIOS's
	pshs	y		; $F8E5 Obj_Will_Hit_u: Y moved by U's y, x
	pshs	a,b,x,y
	ldd	4,s
	adda	,u
	addb	1,u
oh1:	std	4,s
	bra	oh2
	pshs	y		; $F8F3 Obj_Will_Hit: Y moved by U
	pshs	a,b,x,y
	tfr	u,d
	adda	4,s
	addb	5,s
	bra	oh1
	pshs	y		; $F8FF Obj_Hit: X within A, B of Y?
	pshs	a,b,x,y
oh2:	tfr	s,x
	clrb
oh3:	abx
	lda	4,x
	adda	,x
	bvc	oh4
	lda	#$7F
oh4:	cmpa	2,x
	blt	oh6
	lda	4,x
	suba	,x
	bvc	oh5
	lda	#$80
oh5:	cmpa	2,x
	bgt	oh6
	incb
	cmpb	#2
	blo	oh3
	orcc	#$01		; C: a hit
	bra	oh7
oh6:	andcc	#$FE
oh7:	puls	a,b,x,y
	puls	y,pc
	org	$F92E
	jmp	s_expl		; $F92E Explosion_Snd

	org	$F940
s_wait:	ldx	#m_wait
	bra	noargs
s_reset: ldx	#m_reset
	bra	noargs
s_joy:	ldx	#m_joy
	bra	noargs
s_sound: ldx	#m_sound
noargs:	jsr	pname
	jmp	pdpnl
s_btns:	ldx	#m_btns
	jsr	pname
	jsr	pdpnl
	lda	#$5A
	rts
s_rand:	ldx	#m_rand
	jsr	pname
	jsr	pdpnl
	lda	#$33
	rts
s_inten: ldx	#m_inten
	jsr	pname
	jsr	phexa
	jmp	pdpnl
s_move:	ldx	#m_move
	bra	yx
s_move7: ldx	#m_move7
	bra	yx
s_dot:	ldx	#m_dot
yx:	jsr	pname
	jsr	phexa
	tfr	b,a
	jsr	phexa
	jmp	pdpnl
s_line:	ldx	#m_line
	jsr	pname
	jsr	phexa
	tfr	b,a
	jsr	phexa
	lda	MISCCNT		; (must be 0 for one line)
	jsr	phexa
	jmp	pdpnl
s_print: ldx	#m_print
	jsr	pname
	jsr	phexa
	tfr	b,a
	jsr	phexa
	lda	#$20
	sta	IO_OUT
pstr:	lda	,u+		; the string, to its $80
	cmpa	#$80
	beq	pstr2
	sta	IO_OUT
	bra	pstr
pstr2:	jmp	pdpnl
s_vlc:	pshs	x
	ldx	#m_vlc
	jsr	pname
	puls	x
	lda	,x		; the count, and the first line
	jsr	phexa
	lda	1,x
	jsr	phexa
	lda	2,x
	jsr	phexa
	jmp	pdpnl
s_music: ldx	#m_music
	jsr	pname
	tfr	u,d
	jsr	phexa
	tfr	b,a
	jsr	phexa2
	jmp	pdpnl

; the list routines: the name, then what they take, and the list as
; they would read it
s_vla:	pshs	x		; Draw_VL_a: A, then A + 1 lines
	ldx	#m_vla
	jsr	pname
	puls	x
	tfr	a,b		; (phexa changes A)
	jsr	phexa
	bra	lines
s_movdr: pshs	x		; Mov_Draw_VL_a: A, the move, A lines
	ldx	#m_movdr
	jsr	pname
	puls	x
	tfr	a,b
	jsr	phexa
	jsr	pair
	decb
	bra	lines
s_vlcs:	pshs	x		; Draw_VLcs: n, the scale, n + 1 lines
	ldx	#m_vlcs
	jsr	pname
	puls	x
	ldb	,x+
	tfr	b,a
	jsr	phexa
	lda	,x+
	jsr	phexa
	bra	lines
s_pat:	pshs	x		; Draw_Pat_VL_a: A, Vec_Pattern, A + 1 lines
	ldx	#m_pat
	jsr	pname
	puls	x
	tfr	a,b
	jsr	phexa
	lda	PATTERN
	jsr	phexa
	bra	lines
s_dotl:	pshs	x		; Dot_List: Vec_Misc_Count + 1 dots
	ldx	#m_dotl
	jsr	pname
	puls	x
	ldb	MISCCNT
	tfr	b,a
	jsr	phexa
lines:	bsr	pair		; B + 1 y, x pairs at X
	decb
	bpl	lines
	jmp	pdpnl
pair:	lda	#$20		; " y,x" from X (keeping B)
	sta	IO_OUT
	lda	,x+
	jsr	phexa2
	lda	#',
	sta	IO_OUT
	lda	,x+
	jmp	phexa2
s_vlp:	pshs	x		; Draw_VLp: pattern, y, x until a positive
	ldx	#m_vlp		; pattern
	jsr	pname
	puls	x
vlp1:	ldb	,x+
	tfr	b,a
	jsr	phexa
	tstb
	bgt	vlp2
	bsr	pair
	bra	vlp1
vlp2:	jmp	pdpnl
s_rot:	pshs	x		; Rot_VL_ab: A, B, the points; $77 at U
	ldx	#m_rot
	jsr	pname
	puls	x
	jsr	phexa
	pshs	a
	tfr	b,a
	jsr	phexa
	puls	a
	lda	#$77
	sta	,u
	bra	lines
s_plist: ldx	#m_plist	; Print_List: each y, x and string
	jsr	pname
pl1:	tst	,u
	beq	pl3
	lda	#$20
	sta	IO_OUT
	lda	,u+
	jsr	phexa2
	lda	#',
	sta	IO_OUT
	lda	,u+
	jsr	phexa2
	lda	#$20
	sta	IO_OUT
pl2:	lda	,u+
	cmpa	#$80
	beq	pl1
	sta	IO_OUT
	bra	pl2
pl3:	jmp	pdpnl
s_ships: pshs	x		; Print_Ships: A, B, X
	ldx	#m_ships
	jsr	pname
	puls	x
	jsr	phexa
	tfr	b,a
	jsr	phexa
	tfr	x,d
	jsr	phexa
	tfr	b,a
	jsr	phexa2
	jmp	pdpnl
s_clrsc: pshs	x		; Clear_Score: "     0" at X
	ldd	#$2020
	std	,x++
	std	,x++
	sta	,x+
	ldd	#$3080
	std	,x
	ldx	#m_clrsc
	jsr	pname
	puls	x
	jmp	pdpnl
s_addsa: pshs	x		; Add_Score_a: A, and the score
	ldx	#m_addsa
	jsr	pname
	puls	x
	jsr	phexa
	bra	pscore
s_addsd: pshs	x		; Add_Score_d: D, and the score
	ldx	#m_addsd
	jsr	pname
	puls	x
	jsr	phexa
	tfr	b,a
	jsr	phexa2
pscore:	lda	#$20		; " [score at X]"
	sta	IO_OUT
	lda	#'[
	sta	IO_OUT
ps1:	lda	,x+
	cmpa	#$80
	beq	ps2
	sta	IO_OUT
	bra	ps1
ps2:	lda	#']
	sta	IO_OUT
	jmp	pdpnl
s_hisc:	pshs	x		; New_High_Score: the scores at X and U
	ldx	#m_hisc
	jsr	pname
	puls	x
	bsr	pscore2
	tfr	u,x
	bsr	pscore2
	jmp	pdpnl
pscore2: lda	#$20
	sta	IO_OUT
	lda	#'[
	sta	IO_OUT
ps3:	lda	,x+
	cmpa	#$80
	beq	ps4
	sta	IO_OUT
	bra	ps3
ps4:	lda	#']
	sta	IO_OUT
	rts

; sound and the start screen
s_sbyte: ldx	#m_sbyte	; Sound_Byte: A, B
	jmp	yx
s_clrsn: ldx	#m_clrsn	; Clear_Sound
	jmp	noargs
s_sbyts: ldx	#m_sbyts	; Sound_Bytes: the pairs at U, to a
	jsr	pname		; negative register
sb1:	lda	,u+
	bmi	sb2
	jsr	phexa
	lda	#',
	sta	IO_OUT
	lda	,u+
	jsr	phexa2
	bra	sb1
sb2:	jmp	pdpnl
s_selg:	std	$C879		; Select_Game: A, B, chosen
	ldx	#m_selg
	jmp	yx
s_expl:	ldx	#m_expl		; Explosion_Snd: the 4 bytes at U
	jsr	pname
	lda	,u
	jsr	phexa
	lda	1,u
	jsr	phexa
	lda	2,u
	jsr	phexa
	lda	3,u
	jsr	phexa
	jmp	pdpnl

; pname: the name at X, to its 0 (keeping A)
pname:	pshs	a
pn1:	lda	,x+
	beq	pn2
	sta	IO_OUT
	bra	pn1
pn2:	puls	a,pc
; phexa: a space and A in hex; phexa2: A in hex
phexa:	pshs	a
	lda	#$20
	sta	IO_OUT
	puls	a
phexa2:	pshs	a
	lsra
	lsra
	lsra
	lsra
	bsr	digit
	puls	a
	anda	#$0F
digit:	adda	#$30
	cmpa	#$39
	bls	dig2
	adda	#7
dig2:	sta	IO_OUT
	rts
; pdpnl: " dp", DP and a newline
pdpnl:	ldx	#m_dp
	bsr	pname
	tfr	dp,a
	bsr	phexa2
	lda	#$0A
	sta	IO_OUT
	rts

m_wait:	fcc	"Wait_Recal"
	fcb	0
m_reset: fcc	"Reset0Ref"
	fcb	0
m_joy:	fcc	"Joy_Digital"
	fcb	0
m_sound: fcc	"Do_Sound"
	fcb	0
m_btns:	fcc	"Read_Btns"
	fcb	0
m_rand:	fcc	"Random"
	fcb	0
m_inten: fcc	"Intensity_a"
	fcb	0
m_move:	fcc	"Moveto_d"
	fcb	0
m_move7: fcc	"Moveto_d_7F"
	fcb	0
m_vla:	fcc	"Draw_VL_a"
	fcb	0
m_movdr: fcc	"Mov_Draw_VL_a"
	fcb	0
m_vlcs:	fcc	"Draw_VLcs"
	fcb	0
m_pat:	fcc	"Draw_Pat_VL_a"
	fcb	0
m_dotl:	fcc	"Dot_List"
	fcb	0
m_vlp:	fcc	"Draw_VLp"
	fcb	0
m_rot:	fcc	"Rot_VL_ab"
	fcb	0
m_plist: fcc	"Print_List"
	fcb	0
m_ships: fcc	"Print_Ships"
	fcb	0
m_clrsc: fcc	"Clear_Score"
	fcb	0
m_addsa: fcc	"Add_Score_a"
	fcb	0
m_addsd: fcc	"Add_Score_d"
	fcb	0
m_hisc:	fcc	"New_High_Score"
	fcb	0
m_sbyte: fcc	"Sound_Byte"
	fcb	0
m_clrsn: fcc	"Clear_Sound"
	fcb	0
m_sbyts: fcc	"Sound_Bytes"
	fcb	0
m_selg:	fcc	"Select_Game"
	fcb	0
m_expl:	fcc	"Explosion_Snd"
	fcb	0
m_dot:	fcc	"Dot_d"
	fcb	0
m_line:	fcc	"Draw_Line_d"
	fcb	0
m_print: fcc	"Print_Str_d"
	fcb	0
m_vlc:	fcc	"Draw_VLc"
	fcb	0
m_music: fcc	"Init_Music_chk"
	fcb	0
m_dp:	fcc	" dp "
	fcb	0
