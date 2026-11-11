; stands in for Disk BASIC's ROM on sim6809, for testing the Color BASIC
; target's files (bcc09 -Me, libc/cb/disk.c): linked at $C000, it has
; the ROM's "DK", the DSKCON vector at $C004 and the address of DSKCON's
; parameters ($EA: DCOPC, DCDRV, DCTRK, DSEC, DCBPT, DCSTA) at $C006.
;
; Its DSKCON reads (2) and writes (3) drive 0's tracks 16 to 18, which
; are kept in memory from $C100 (64K can't hold a whole disk); anything
; else gives DCSTA $10.  Its first call formats them: a FAT whose
; granules 32 to 35 (tracks 16 and 18, which Disk BASIC uses first) are
; free and the rest marked used, and an empty directory.  It prints # if
; it is called with DP other than 0, as cbrom.s's routines do.

DCOPC	equ	$ea
DCDRV	equ	$eb
DCTRK	equ	$ec
DSEC	equ	$ed
DCBPT	equ	$ee
DCSTA	equ	$f0
DISK	equ	$c100		; tracks 16, 17 and 18
IO_OUT	equ	$ff00		; the simulator's output
TRACK	equ	18*256

	.text
	entry	rom		; (ld09 needs one; it isn't run)
rom:	fcc	"DK"
	bra	rom
	fdb	dskcon		; $C004
	fdb	DCOPC		; $C006

dskcon:	pshs	d,x,y,u
	tfr	dp,a		; # if DP isn't 0
	tsta
	beq	dk0
	lda	#'#
	sta	IO_OUT
dk0:	tst	formatted
	bne	dk1
	bsr	format
dk1:	lda	#$10		; (an error, unless all is well)
	sta	>DCSTA
	tst	>DCDRV
	bne	dkx
	ldb	>DCTRK
	subb	#16
	cmpb	#2
	bhi	dkx
	lda	>DSEC
	beq	dkx
	cmpa	#18
	bhi	dkx
	deca			; X: the sector, from DISK
	ldx	#DISK
	tstb
	beq	dk2
dk3:	leax	TRACK,x
	decb
	bne	dk3
dk2:	tfr	a,b
	clra
	exg	a,b		; D: sector * 256
	leax	d,x
	ldy	>DCBPT
	ldb	>DCOPC
	cmpb	#2
	beq	read
	cmpb	#3
	bne	dkx
	exg	x,y		; write: from the buffer to the disk
read:	clrb			; copy 256 bytes from X to Y
cp:	lda	,x+
	sta	,y+
	decb
	bne	cp
	clr	>DCSTA
dkx:	puls	d,x,y,u,pc

; the FAT (track 17 sector 2): $FF for granules 32 to 35, $C0 (the last
; of a file, no sectors) for the others; the directory (sectors 3 to 11):
; $FF
format:	inc	formatted
	ldx	#DISK+TRACK+256	; track 17, sector 2
	clrb
f1:	lda	#$c0
	cmpb	#32
	blo	f2
	cmpb	#35
	bhi	f2
	lda	#$ff
f2:	sta	,x+
	incb
	cmpb	#68
	blo	f1
f3:	clr	,x+		; (the rest of the sector)
	incb
	bne	f3
	ldy	#9*256		; the directory
f4:	lda	#$ff
	sta	,x+
	leay	-1,y
	bne	f4
	rts

	.data
formatted: fcb	0
