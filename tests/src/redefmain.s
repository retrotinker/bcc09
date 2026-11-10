; redefmain.s - defines dup, which the library redeflib.a defines too;
; nothing else in the library is needed, so its member isn't linked
	.text
	entry	start
	export	dup
start:	jsr	dup
	rts
dup:	rts
