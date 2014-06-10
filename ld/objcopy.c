/*
 * Copyright 2014 John W. Linville <linville@tuxdriver.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation. See README and COPYING for
 * more details.
 */

#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <unistd.h>
#include <errno.h>
#include <getopt.h>

#include "x86_aout.h"

enum output_formats {
	BINARY,
	DECB_BIN,
	OS9_MODULE,
};

unsigned int textaddr;
unsigned int dataaddr;
unsigned int datasize;
unsigned int modversion;
unsigned int reentrant;
char *os9name;

uint8_t os9crc[3] = { 0xff, 0xff, 0xff };

uint32_t textstart;
uint32_t textend;
uint32_t datastart;

struct {
	char *n_name;
	uint32_t *val;
} searchsyms[] = {
	{
		.n_name = "__btext",
		.val = &textstart,
	},
	{
		.n_name = "__etext",
		.val = &textend,
	},
	{
		.n_name = "__bdata",
		.val = &datastart,
	},
};
#define NUM_SEARCH_SYMS	(sizeof(searchsyms) / sizeof(searchsyms[0]))

static char *progname;

void usage(void)
{
	fprintf(stderr,
		"Usage: %s [-O <output type>] [-T <text address>] [-D <data address>]\n"
		"\t\t[-d <data size>] [-n <module name>] [-v <module version>] [-r]\n"
		"\t\tinfile outfile\n", progname);
	exit(EXIT_FAILURE);
}

void fatal(char *str)
{
	fprintf(stderr, "%s: %s\n", progname, str);
	exit(EXIT_FAILURE);
}

void warning(char *str)
{
	fprintf(stderr, "%s: %s\n", progname, str);
}

void match_syms(FILE *ifd, struct exec header)
{
	struct nlist symbol;
	int i;
	int numsyms = header.a_syms / sizeof(struct nlist);
	int numsearchsyms = NUM_SEARCH_SYMS;

	if (fseek(ifd, A_SYMPOS(header), 0) < 0)
		fatal("Cannot seek to start of symbols");

	while (numsearchsyms && numsyms--) {
		if (fread(&symbol, sizeof(symbol), 1, ifd) != 1)
			fatal("Cannot read symbol information!");

		for (i = 0; i < NUM_SEARCH_SYMS; i++) {
			if (!strncmp(symbol.n_name, searchsyms[i].n_name,
				     sizeof(symbol.n_name))) {
				*searchsyms[i].val = be32toh(symbol.n_value);
				numsearchsyms--;
			}
		}
	}
}

void os9_crc_adjust(uint8_t *buffer, int ssize)
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
		datum ^= os9crc[0];
		os9crc[0]  = os9crc[1];
		os9crc[1]  = os9crc[2];
		os9crc[1] ^= (datum >> 7);
		os9crc[2]  = (datum << 1);
		os9crc[1] ^= (datum >> 2);
		os9crc[2] ^= (datum << 6);
		datum ^= (datum << 1);
		datum ^= (datum << 2);
		datum ^= (datum << 4);

		if (datum & 0x80) {
			os9crc[0] ^= 0x80;
			os9crc[2] ^= 0x21;
		}
	}
}

void write_file(FILE *ifd, FILE *ofd, unsigned int bsize)
{
	unsigned char buffer[1024];
	unsigned int ssize;

	while (bsize > 0) {
		if (bsize > sizeof(buffer))
			ssize = sizeof(buffer);
		else
			ssize = bsize;

		if ((ssize = fread(buffer, 1, ssize, ifd)) <= 0)
			fatal("Error reading segment from executable");

		os9_crc_adjust(buffer, ssize);
		if (fwrite(buffer, 1, ssize, ofd) != ssize)
			fatal("Error writing output file");
		bsize -= ssize;
	}
}

void write_zeroes(FILE *ofd, unsigned int bsize)
{
	unsigned char buffer[1024];
	unsigned int ssize;

	memset(buffer, 0, sizeof(buffer));
	while (bsize > 0) {
		if (bsize > sizeof(buffer))
			ssize = sizeof(buffer);
		else
			ssize = bsize;

		os9_crc_adjust(buffer, ssize);
		if (fwrite(buffer, 1, ssize, ofd) != ssize)
			fatal("Error writing zeroes to output file");
		bsize -= ssize;
	}
}

void raw_output(FILE *ifd, FILE *ofd, struct exec header)
{
	if (fseek(ifd, A_TEXTPOS(header), 0) < 0)
		fatal("Cannot seek to start of text");

	write_file(ifd, ofd, header.a_text);

	if (fseek(ifd, A_DATAPOS(header), 0) < 0)
		fatal("Cannot seek to start of data");

	write_file(ifd, ofd, header.a_data);
}

void decb_output(FILE *ifd, FILE *ofd, struct exec header)
{
	uint8_t binhead[5], binfoot[5];
	int binsize;

	if (!textaddr)
		textaddr = textstart;
	if (!textaddr)
		warning("BIN load address is zero");

	binsize = header.a_text;
	if (!(header.a_flags & A_SEP) ||
	    (!dataaddr && datastart == textend))
		binsize += header.a_data;

	binhead[0] = 0;
	binhead[1] = (binsize & 0xff00) >> 8;
	binhead[2] =  binsize & 0x00ff;
	binhead[3] = (textaddr & 0xff00) >> 8;
	binhead[4] =  textaddr & 0x00ff;

	if (fwrite(binhead, 1, sizeof(binhead), ofd) != sizeof(binhead))
		fatal("Error writing DECB BIN header to outfile");

	if (fseek(ifd, A_TEXTPOS(header), 0) < 0)
		fatal("Cannot seek to start of text");

	write_file(ifd, ofd, header.a_text);

	if ((header.a_flags & A_SEP) &&
	    (dataaddr || datastart != textend)) {
		if (!dataaddr)
			dataaddr = datastart;
		if (!dataaddr)
			warning("BIN data load address is zero");

		binsize = header.a_data;

		binhead[0] = 0;
		binhead[1] = (binsize & 0xff00) >> 8;
		binhead[2] =  binsize & 0x00ff;
		binhead[3] = (dataaddr & 0xff00) >> 8;
		binhead[4] =  dataaddr & 0x00ff;

		if (fwrite(binhead, 1, sizeof(binhead), ofd) != sizeof(binhead))
			fatal("Error writing DECB BIN data header to outfile");
	}

	if (fseek(ifd, A_DATAPOS(header), 0) < 0)
		fatal("Cannot seek to start of data");

	write_file(ifd, ofd, header.a_data);

	binfoot[0] = 0xff;
	binfoot[1] = binfoot[2] = 0;
	binfoot[3] = (header.a_entry & 0xff00) >> 8;
	binfoot[4] =  header.a_entry & 0x00ff;

	if (fwrite(binfoot, 1, sizeof(binfoot), ofd) != sizeof(binfoot))
		fatal("Error writing DECB BIN footer to outfile");
}

void os9_output(FILE *ifd, FILE *ofd, struct exec header)
{
	uint8_t os9hdr[13] = {
		0x87, 0xcd,
	};
	unsigned short modsize, heapsize;
	unsigned int i, namelen, nameoffset;
	unsigned char hdrchk = 0;

	namelen = strlen(os9name);

	heapsize = header.a_total - header.a_text -
			header.a_data - header.a_bss;
	if (datasize < heapsize)
		datasize = heapsize;
	if (!datasize)
		fatal("OS-9 module data size is zero");

	/* can claim reentrant if no r/w static data allocations */
	if (!reentrant)
		reentrant = !(header.a_data + header.a_bss);

	nameoffset = sizeof(os9hdr) + header.a_text +
			header.a_data + header.a_bss;
	modsize = nameoffset + namelen + sizeof(os9crc);

	*((unsigned short *)&os9hdr[2]) = htobe16(modsize);
	*((unsigned short *)&os9hdr[4]) = htobe16(nameoffset);

	os9hdr[6] = 0x11; /* 6809 executable */

	if (modversion > 0x7f)
		fatal("OS-9 module version is too large");
	os9hdr[7] = modversion;
	if (reentrant)
		os9hdr[7] |= 0x80;

	for (i = 0; i < 8; i++)
		hdrchk ^= os9hdr[i];
	os9hdr[8] = hdrchk ^ 0xff;

	*((unsigned short *)&os9hdr[9]) =
		htobe16(sizeof(os9hdr) + header.a_entry);

	/* Request stack + parameter storage */
	*((unsigned short *)&os9hdr[11]) = htobe16(datasize);

	os9_crc_adjust(os9hdr, sizeof(os9hdr));
	if (fwrite(os9hdr, 1, sizeof(os9hdr), ofd) != sizeof(os9hdr))
		fatal("Error writing OS-9 module header to outfile");

	if (fseek(ifd, A_TEXTPOS(header), 0) < 0)
		fatal("Cannot seek to start of text");

	write_file(ifd, ofd, header.a_text);

	if (fseek(ifd, A_DATAPOS(header), 0) < 0)
		fatal("Cannot seek to start of data");

	write_file(ifd, ofd, header.a_data);

	write_zeroes(ofd, header.a_bss);

	/* End of string needs MSB set... */
	os9name[namelen - 1] |= 0x80;

	os9_crc_adjust((uint8_t *)os9name, namelen);
	if (fwrite(os9name, 1, namelen, ofd) != namelen)
		fatal("Error writing OS-9 module name to outfile");

	os9crc[0] ^= 0xff;
	os9crc[1] ^= 0xff;
	os9crc[2] ^= 0xff;

	if (fwrite(os9crc, 1, sizeof(os9crc), ofd) != sizeof(os9crc))
		fatal("Error writing OS-9 module CRC to outfile");
}

int main(int argc, char *argv[])
{
	FILE *ifd, *ofd;
	int i, opt;
	struct exec header;
	enum output_formats outform = BINARY;

	progname = argv[0];
	while ((opt = getopt(argc, argv, "O:T:D:d:n:v:r")) != -1) {
		switch(opt) {
		case 'O':
			if (!strncmp(optarg, "binary", 3))
				outform = BINARY;
			else if(!strncmp(optarg, "decb", 4))
				outform = DECB_BIN;
			else if (!strncmp(optarg, "os9", 3))
				outform = OS9_MODULE;
			else
				fatal("Unknown output format!\n");
			break;
		case 'T':
			errno = 0;
			textaddr = strtol(optarg, NULL, 0);
			if (errno)
				fatal("Bad text address value");
			break;
		case 'D':
			errno = 0;
			dataaddr = strtol(optarg, NULL, 0);
			if (errno)
				fatal("Bad data address value");
			break;
		case 'd':
			errno = 0;
			datasize = strtol(optarg, NULL, 0);
			if (errno)
				fatal("Bad data size value");
			break;
		case 'n':
			os9name = optarg;
			break;
		case 'v':
			errno = 0;
			modversion = strtol(optarg, NULL, 0);
			if (errno)
				fatal("Bad version value");
			break;
		case 'r':
			reentrant = 1;
			break;
		default:
			usage();
			exit(EXIT_FAILURE);
		}
	}

	if (optind > argc - 2) {
		usage();
		exit(EXIT_FAILURE);
	}

	ifd = fopen(argv[optind], "r");
	if (ifd == 0)
		fatal("Cannot open input file");

	if (fread(&header, A_MINHDR, 1, ifd) != 1)
		fatal("Incomplete executable header");

	if (BADMAG(header))
		fatal("Input file has bad magic number");

	exec_header_adjust(&header);

	match_syms(ifd, header);

	ofd = fopen(argv[optind + 1], "w");
	if (ofd == 0)
		fatal("Cannot open output file");

	switch(outform) {
	case BINARY:
		raw_output(ifd, ofd, header);
		break;
	case DECB_BIN:
		decb_output(ifd, ofd, header);
		break;
	case OS9_MODULE:
		if (!os9name) {
			os9name = argv[optind + 1];
			for (i = 0; i < strlen(os9name); i++)
				os9name[i] = toupper(os9name[i]);
		}
		os9_output(ifd, ofd, header);
		break;
	};

	fclose(ifd);
	fclose(ofd);

	exit(EXIT_SUCCESS);
}
