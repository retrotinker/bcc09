#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <errno.h>

#include "x86_aout.h"

#ifndef __OUT_OK

main()
{
	fprintf(stderr, "Compile error: struct exec invalid\n");
	exit(1);
}

#else

FILE *ifd;
struct exec header;

uint8_t binhead[5], binfoot[5];

void fatal(char *str)
{
	fprintf(stderr, "decbcopy: %s\n", str);
	exit(2);
}

void write_file(FILE *ofd, long bsize)
{
	char buffer[1024];
	int ssize;

	while (bsize > 0) {
		if (bsize > sizeof(buffer))
			ssize = sizeof(buffer);
		else
			ssize = bsize;

		if ((ssize = fread(buffer, 1, ssize, ifd)) <= 0)
			fatal("Error reading segment from executable");
		if (fwrite(buffer, 1, ssize, ofd) != ssize)
			fatal("Error writing output file");
		bsize -= ssize;
	}
}

int main(int argc, char *argv[])
{
	FILE *ofd;
	int loadaddr, binsize;

	if (argc != 4)
		fatal("Usage: decbcopy a.out outfile loadaddr");

	errno = 0;
	loadaddr = strtol(argv[3], NULL, 0);
	if (errno)
		fatal("Bad loadaddr value");

	ifd = fopen(argv[1], "r");
	if (ifd == 0)
		fatal("Cannot open input file");

	if (fread(&header, A_MINHDR, 1, ifd) != 1)
		fatal("Incomplete executable header");

	if (BADMAG(header))
		fatal("Input file has bad magic number");

	exec_header_adjust(&header);

	ofd = fopen(argv[2], "w");
	if (ofd == 0)
		fatal("Cannot open output file");

	binsize = header.a_text + header.a_data;

	binhead[0] = 0;
	binhead[1] = (binsize & 0xff00) >> 8;
	binhead[2] =  binsize & 0x00ff;
	binhead[3] = (loadaddr & 0xff00) >> 8;
	binhead[4] =  loadaddr & 0x00ff;

	if (fwrite(binhead, 1, sizeof(binhead), ofd) != sizeof(binhead))
		fatal("Error writing DECB binary header to outfile");

	if (fseek(ifd, A_TEXTPOS(header), 0) < 0)
		fatal("Cannot seek to start of text");

	write_file(ofd, header.a_text);

	if (fseek(ifd, A_DATAPOS(header), 0) < 0)
		fatal("Cannot seek to start of data");

	write_file(ofd, header.a_data);

	binfoot[0] = 0xff;
	/* offset 1 & 2 should already be zero */
	binfoot[3] = (header.a_entry & 0xff00) >> 8;
	binfoot[4] =  header.a_entry & 0x00ff;

	if (fwrite(binfoot, 1, sizeof(binfoot), ofd) != sizeof(binfoot))
		fatal("Error writing DECB binary footer to outfile");

	fclose(ofd);

	return 0;
}

#endif
