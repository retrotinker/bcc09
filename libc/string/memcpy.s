; memcpy(dst, src, n): copy n bytes from src to dst, and return dst
;
; bcc09 also calls it to copy structures.  dst arrives in X (the first
; argument), src and n on the stack.  Changes D and CC.

	.text
	export	_memcpy

_memcpy:
	pshs	x,y,u		; 0,S: dst  2,S: Y  4,S: U  6,S: return
				; 8,S: src  10,S: n
	ldu	8,s		; src
	ldy	10,s		; the count, in Y because LEAY sets Z
	beq	mcdone		; (LEAU doesn't)
mcloop:	lda	,u+
	sta	,x+
	leay	-1,y
	bne	mcloop
mcdone:	puls	x,y,u,pc	; X: dst again
