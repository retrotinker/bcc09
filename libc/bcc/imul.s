; imul, imulu: 16-bit multiply for bcc09
;
; D = D * X.  The low 16 bits of the product are the same for signed and
; unsigned operands, so both names are the same routine.  Changes D and
; CC only.

	.text
	export	imul
	export	imulu

imul:
imulu:
	pshs	d,x		; 0,S = a high, 1,S = a low
				; 2,S = b high, 3,S = b low
	lda	1,s
	ldb	2,s
	mul			; a low * b high (only its low byte counts)
	stb	2,s
	lda	0,s
	ldb	3,s
	mul			; a high * b low (likewise)
	addb	2,s
	stb	2,s		; the cross terms, for the high byte
	lda	1,s
	ldb	3,s
	mul			; a low * b low
	adda	2,s
	leas	4,s
	rts
