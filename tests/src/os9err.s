; os9err.s - OS9's errors: a code that isn't a byte, one that isn't
; absolute (an import, a label), and an undefined one

	.text
	import	ext
	os9	$100
	os9	ext
	os9	here
	os9	F$None
here:	rts
