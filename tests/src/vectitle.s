; vectitle.s - a Vectrex cartridge header of a program's own (see
; vectrex.h): linked with it, it takes the place of libvec.a's
	loc	12
	export	__vec_header
__vec_header:
	fcc	"g GCE 2026"
	fcb	$80
	fdb	$FD0D
	fcb	$F8,$50,$20,$D0
	fcc	"MY GAME"
	fcb	$80
	fcb	0
