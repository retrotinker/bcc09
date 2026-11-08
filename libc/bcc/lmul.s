; lmul_b, lmulu_b: 32-bit multiply for bcc09
;
; D:X = D:X * [Y]: D holds the high word and X the low one, and Y points
; at the other operand.  The low 32 bits of the product are the same for
; signed and unsigned operands.  With a = ah:al and b = bh:bl in 16-bit
; words, the product is al * bl + ((ah * bl + al * bh) << 16), and the
; 8-bit MUL builds each part.  Changes D, X and CC.

	.text
	export	lmul_b
	export	lmulu_b

lmul_b:
lmulu_b:
	pshs	d,x		; 4,S: ah (bytes 4, 5)  6,S: al (bytes 6, 7)
	leas	-4,s		; 0,S: the product, 4 bytes
				; b: 0,Y bh (bytes 0, 1)  2,Y bl (bytes 2, 3)
; al * bl, all 32 bits
	lda	7,s
	ldb	3,y
	mul
	std	2,s		; low * low: bytes 2, 3
	lda	6,s
	ldb	2,y
	mul
	std	0,s		; high * high: bytes 0, 1
	lda	7,s
	ldb	2,y
	mul			; the cross terms, into bytes 1, 2
	addd	1,s
	std	1,s
	bcc	lmc1
	inc	0,s
lmc1:	lda	6,s
	ldb	3,y
	mul
	addd	1,s
	std	1,s
	bcc	lmc2
	inc	0,s
; + the low 16 bits of ah * bl and of al * bh, into bytes 0, 1
lmc2:	lda	5,s
	ldb	3,y
	mul
	addd	0,s
	std	0,s
	lda	4,s
	ldb	3,y
	mul
	addb	0,s
	stb	0,s
	lda	5,s
	ldb	2,y
	mul
	addb	0,s
	stb	0,s
	lda	7,s
	ldb	1,y
	mul
	addd	0,s
	std	0,s
	lda	6,s
	ldb	1,y
	mul
	addb	0,s
	stb	0,s
	lda	7,s
	ldb	0,y
	mul
	addb	0,s
	stb	0,s
	puls	d,x		; the product
	leas	4,s
	rts
