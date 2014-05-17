#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

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

uint8_t crc[3] = { 0xff, 0xff, 0xff };

void crc_adjust(uint8_t *buffer, int ssize)
{
	int i;
	uint8_t datum;

	for (i = 0; i < ssize; i++) {
		datum = *buffer++;

		/*
		 * Not sure I grok the original
		 * CRC algorithm...  The algorithm
		 * below is based upon assembly code
		 * in the NitrOS-9 repository...
		 */
		datum  ^= crc[0];
		crc[0]  = crc[1];
		crc[1]  = crc[2];
		crc[1] ^= (datum >> 7);
		crc[2]  = (datum << 1);
		crc[1] ^= (datum >> 2);
		crc[2] ^= (datum << 6);
		datum  ^= (datum << 1);
		datum  ^= (datum << 2);
		datum  ^= (datum << 4);

		if (datum & 0x80) {
			crc[0] ^= 0x80;
			crc[2] ^= 0x21;
		}
	}
}

void fatal(char *str)
{
	fprintf(stderr, "os9copy: %s\n", str);
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
		crc_adjust(buffer, ssize);
		if (fwrite(buffer, 1, ssize, ofd) != ssize)
			fatal("Error writing output file");
		bsize -= ssize;
	}
}

int main(int argc, char *argv[])
{
	FILE *ofd;
	uint8_t os9hdr[13] = {
		0x87, 0xcd,
	};
	unsigned short modsize;
	int i, namelen;
	unsigned char hdrchk = 0;
	unsigned short datasize = 400;

	if (argc != 4)
		fatal("Usage: os9copy a.out outfile modname");

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

	namelen = strlen(argv[3]);

	modsize = header.a_text + header.a_data +
			sizeof(os9hdr) + namelen + sizeof(crc);

	*((unsigned short *)&os9hdr[2]) = htobe16(modsize);
	*((unsigned short *)&os9hdr[4]) = htobe16(sizeof(os9hdr));

	os9hdr[6] = 0x11; /* 6809 executable */
	os9hdr[7] = 0x81; /* re-entrant, version 1 */

	for (i = 0; i < 8; i++)
		hdrchk ^= os9hdr[i];
	os9hdr[8] = hdrchk ^ 0xff;

	/* For now, presume execution starts right after the module name... */
	*((unsigned short *)&os9hdr[9]) =
		htobe16(sizeof(os9hdr) + namelen);

	/* Request 400 bytes of storage (~200 stack + ~200 parameter) */
	*((unsigned short *)&os9hdr[11]) = htobe16(datasize);

	crc_adjust(os9hdr, sizeof(os9hdr));
	if (fwrite(os9hdr, 1, sizeof(os9hdr), ofd) != sizeof(os9hdr))
		fatal("Error writing OS-9 module header to outfile");

	/* End of string needs MSB set... */
	argv[3][namelen - 1] |= 0x80;

	crc_adjust(argv[3], namelen);
	if (fwrite(argv[3], 1, namelen, ofd) != namelen)
		fatal("Error writing OS-9 module name to outfile");

	if (fseek(ifd, A_TEXTPOS(header), 0) < 0)
		fatal("Cannot seek to start of text");

	write_file(ofd, header.a_text);

	if (fseek(ifd, A_DATAPOS(header), 0) < 0)
		fatal("Cannot seek to start of data");

	write_file(ofd, header.a_data);

	crc[0] ^= 0xff;
	crc[1] ^= 0xff;
	crc[2] ^= 0xff;

	if (fwrite(crc, 1, sizeof(crc), ofd) != sizeof(crc))
		fatal("Error writing OS-9 module CRC to outfile");

	fclose(ofd);

	return 0;
}

#endif
