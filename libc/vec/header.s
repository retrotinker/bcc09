; header: the default Vectrex cartridge header (bcc09 -Mv, libvec.a),
; linked when the program has no module of its own defining
; __vec_header: vectrex.ld puts segment 12 at $0000.  The BIOS checks
; for "g GCE" at the start, shows the year after it on its screen, plays
; the music (Music1, the BIOS's own tune, at $FD0D), and shows the title;
; then it runs the code after the header's 0, crtvec.o's.
;
; A program's own header is the same, with its title (or titles: each
; line is a height, a width, a Y and an X, then the text, in capitals,
; ended by $80; the header ends with a 0):
;
;	loc	12
;	export	__vec_header
; __vec_header:
;	fcc	"g GCE 2026"
;	fcb	$80
;	fdb	$FD0D		; the music
;	fcb	$F8,$50,$20,$D0	; height, width, Y, X
;	fcc	"MY GAME"
;	fcb	$80
;	fcb	0
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	loc	12
	export	__vec_header

__vec_header:
	fcc	"g GCE 2026"
	fcb	$80
	fdb	$FD0D
	fcb	$F8,$50,$20,$E0
	fcc	"BCC09"
	fcb	$80
	fcb	0
