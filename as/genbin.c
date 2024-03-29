/* genbin.c - binary code generation routines for assembler */

#include "syshead.h"
#include "const.h"
#include "type.h"
#include "address.h"
#include "file.h"
#include "globvar.h"

#ifdef USE_FIXED_HEAP
PRIVATE char *asmbeg;		/* beginning of assembler code */
				/* for overwrite check */
				/* bss-init to zero = NULL and not changed */
#endif

/* Sneaky stuff, the start of a binary file can be _negative_ for the I80386
   assembler. The -ve addresses are ones over 2GB (or "org -32") */
PRIVATE offset_t binfbuf;	/* binary code buffer for file (counter) */
PRIVATE offset_t binmax;	/* maximum value of binmbuf for pass 1 */
PRIVATE offset_t binmin;	/* minimum value of binmbuf for pass 1 */
#define PT offset_t

FORWARD void putbinoffset P((offset_t offset, count_t size));

/* write header to binary file */

PUBLIC void binheader()
{
#ifdef BINSYM
	if ((outfd = binfil) != 0x0 && binmbuf_set && binmax >= binmin) {
		writec(0x0);	/* binary header byte */
#ifdef LONG_BINHEADER
		writeoff(binmax - binmin);	/* program length */
		writeoff(binfbuf = binmin);	/* program start */
#else
		writew((unsigned)(binmax - binmin));	/* program length */
		writew((unsigned)(binfbuf = binmin));	/* program start */
#endif
	}
#else
	if ((outfd = symfil) && binmbuf_set && binmax >= binmin) {
		int sft;
		writec('+');
		writec(' ');
		for (sft = SIZEOF_OFFSET_T * 8 - 4; sft >= 0; sft -= 4)
			writec(hexdigit[(binmin >> sft) & 0xF]);
		writesn(" ----- $start");

		writec('+');
		writec(' ');
		for (sft = SIZEOF_OFFSET_T * 8 - 4; sft >= 0; sft -= 4)
			writec(hexdigit[(binmax >> sft) & 0xF]);
		writesn(" ----- $end");

		binfbuf = binmin;	/* program start */
	}
#endif
}

/* write trailer to binary file */

PUBLIC void bintrailer()
{
#ifdef BINSYM
	if ((outfd = binfil) != 0x0 && (pedata & UNDBIT) != UNDBIT
	    && binmbuf_set) {
		writec(0xFF);	/* binary trailer byte */
		writew(0x0);	/* further trailer bytes */
#ifdef LONG_BINHEADER
		writeoff(pedata & UNDBIT ? binmin : progent);	/* entry point */
#else
		writew(pedata & UNDBIT ? (unsigned)binmin : (unsigned)progent);
#endif
	}
#endif
}

/* generate binary code for current line */

PUBLIC void genbin()
{
	struct address_s *adrptr;
	char *bufptr;
	unsigned char remaining;

	if (binaryg && mcount != 0x0) {
		if (popflags) {
			if (fcflag) {
				bufptr = databuf.fcbuf;
				remaining = mcount;
				do
					putbin(*bufptr++);
				while (--remaining != 0x0);
			}
			if (fdflag) {
				adrptr = databuf.fdbuf;
				remaining = mcount;
				do {
					putbinoffset(adrptr->offset, 0x2);
					++adrptr;
				}
				while ((remaining -= 0x2) != 0x0);
			}
#if SIZEOF_OFFSET_T > 0x2
			if (fqflag) {
				adrptr = databuf.fqbuf;
				remaining = mcount;
				do {
					putbinoffset(adrptr->offset, 0x4);
					++adrptr;
				}
				while ((remaining -= 0x4) != 0x0);
			}
#endif
		} else {
			remaining = mcount - 0x1;	/* count opcode immediately */
			if (page != 0x0) {
				putbin(page);
				--remaining;
			}
			putbin(opcode);
			if (remaining != 0x0) {
				if (postb != 0x0) {
					putbin(postb);
					--remaining;
				}
				if (remaining != 0x0)
					putbinoffset(lastexp.offset, remaining);
			}
		}
		/* else no code for this instruction, or already generated */
	}
}

/* initialise private variables */

PUBLIC void initbin()
{
	binmin = -1;		/* greater than anything */
}

/* write char to binary file or directly to memory */

PUBLIC void putbin(ch)
opcode_pt ch;
{
	if (binfil != 0x0) {
		if (!binaryc) {	/* pass 1, just record limits */
			if ((PT) binmbuf < binmin)
				binmin = binmbuf;
			binmbuf++;
			if ((PT) binmbuf > binmax)
				binmax = binmbuf;
		} else {
#if 0
			if (binfbuf > (PT) binmbuf) {
				error(BWRAP);	/* file buffer ahead of memory buffer */
			} else
#endif
			{
				outfd = binfil;
				if (binfbuf != (PT) binmbuf)
					if (lseek
					    (binfil,
					     (long)((PT) binmbuf - binfbuf),
					     1) < 0)
						error(BWRAP);
				binfbuf = binmbuf;
				writec(ch);
				binmbuf = ++binfbuf;
			}
		}
	}
#ifdef USE_FIXED_HEAP
	else if (binaryc && !(lcdata & UNDBIT))
		/* memory output, and enabled */
	{
		register char *bufptr;

		if ((bufptr = (char *)binmbuf) >= asmbeg && bufptr < temp_buf())
			error(OWRITE);
		else
			*bufptr = ch;
		++binmbuf;
	}
#endif
}

/* write sized offset to binary file or directly to memory */

PRIVATE void putbinoffset(offset, size)
offset_t offset;
count_t size;
{
	char buf[sizeof offset];

#if SIZEOF_OFFSET_T > 0x2
	u4cn(buf, offset, size);
#else
	u2cn(buf, offset, size);
#endif
	putbin(buf[0]);
	if (size > 0x1)
		putbin(buf[1]);
	if (size > 0x2) {
		putbin(buf[2]);
		putbin(buf[3]);
	}
}
