; Disk BASIC's DSKCON, for the Color BASIC target's files (bcc09 -Me,
; disk.c)
;
; __cb_dskcon(op, drive, track, sector, buf): Disk BASIC's DSKCON, through
;   its vector at $C004, with its parameters where $C006 says they are
;   (DCOPC, DCDRV, DCTRK, DSEC, DCBPT and DCSTA: $EA to $F0): op 2 reads
;   sector (1 to 18) of track (0 to 34) on drive (0 to 3) into the 256
;   bytes at buf, 3 writes them; DCSTA, the status (0 if all went well)
; __cb_hasdisk(): nonzero if there is a CoCo's Disk BASIC ROM: "DK" at
;   $C000, and a CoCo (the POLCAT vector, $A000, points into Color BASIC;
;   a Dragon's, into $8000 up, and DragonDOS, whose disks aren't RS-DOS's,
;   starts with "DK" too)
;
; Both keep every register but X, the result (the ROM routines are
; documented to keep them, but this doesn't rely on it).
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

POLCAT	equ	$a000		; Color BASIC's vector
DSKCON	equ	$c004		; Disk BASIC's
DSKPAR	equ	$c006		; (where its parameters are)

	.text
	export	___cb_dskcon
	export	___cb_hasdisk

; op is in X; drive, track, sector and buf are above the return address
___cb_dskcon:
	pshs	d,y,u		; 6,S: return  8,S: drive  10,S: track
	ldu	DSKPAR		;   12,S: sector  14,S: buf
	tfr	x,d
	stb	,u		; DCOPC
	lda	9,s
	sta	1,u		; DCDRV
	lda	11,s
	sta	2,u		; DCTRK
	lda	13,s
	sta	3,u		; DSEC
	ldd	14,s
	std	4,u		; DCBPT
	jsr	[DSKCON]
	ldu	DSKPAR
	ldb	6,u		; DCSTA
	clra
	tfr	d,x
	puls	d,y,u,pc

___cb_hasdisk:
	ldx	#0
	pshs	d
	ldd	$c000
	cmpd	#$444b		; "DK"
	bne	hd1
	ldd	POLCAT
	cmpd	#$a000
	blo	hd1
	leax	1,x
hd1:	puls	d,pc
