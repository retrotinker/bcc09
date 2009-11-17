/* keywords.c - keyword tables for assembler */

#include "syshead.h"
#include "const.h"
#include "type.h"
#include "globvar.h"
#include "opcode.h"

/* --- start of keywords --- */

/* registers */
/* the register code (internal to assembler) is given in 1 byte */
/* the "opcode" field is not used */

PUBLIC char regs[] =
{

    1, 'A', AREG, 0,
    1, 'B', BREG, 0,
    2, 'C', 'C', CCREG, 0,
    1, 'D', DREG, 0,
    2, 'D', 'P', DPREG, 0,
    2, 'P', 'C', PCREG, 0,
    3, 'P', 'C', 'R', PCREG, 0,
    1, 'S', SREG, 0,
    1, 'U', UREG, 0,
    1, 'X', XREG, 0,
    1, 'Y', YREG, 0,
    0				/* end of register list */
};


/* ops */
/* the routine number is given in 1 byte */
/* the opcode is given in 1 byte (it is not used for pseudo-ops) */

PUBLIC char ops[] =
{
    /* pseudo-ops. The "opcode" field is unused and padded with a null byte */
    /* conditionals - must be first */
    4, 'E', 'L', 'S', 'E', ELSEOP, 0,
    6, 'E', 'L', 'S', 'E', 'I', 'F', ELSEIFOP, 0,
    7, 'E', 'L', 'S', 'E', 'I', 'F', 'C', ELSEIFCOP, 0,
    5, 'E', 'N', 'D', 'I', 'F', ENDIFOP, 0,
    2, 'I', 'F', IFOP, 0,
    3, 'I', 'F', 'C', IFCOP, 0,

    /* unconditionals */
    6, '.', 'A', 'L', 'I', 'G', 'N', ALIGNOP, 0,
    6, '.', 'A', 'S', 'C', 'I', 'I', FCCOP, 0,
    6, '.', 'A', 'S', 'C', 'I', 'Z', ASCIZOP, 0,
    5, '.', 'B', 'L', 'K', 'B', RMBOP, 0,
    5, '.', 'B', 'L', 'K', 'W', BLKWOP, 0,
    5, 'B', 'L', 'O', 'C', 'K', BLOCKOP, 0,
    4, '.', 'B', 'S', 'S', BSSOP, 0,
    5, '.', 'B', 'Y', 'T', 'E', FCBOP, 0,
    4, 'C', 'O', 'M', 'M', COMMOP, 0,
    5, '.', 'C', 'O', 'M', 'M', COMMOP1, 0,
    5, '.', 'D', 'A', 'T', 'A', DATAOP, 0,
    6, '.', 'D', 'A', 'T', 'A', '1', FCBOP, 0,
    6, '.', 'D', 'A', 'T', 'A', '2', FDBOP, 0,
#if SIZEOF_OFFSET_T > 2
    6, '.', 'D', 'A', 'T', 'A', '4', FQBOP, 0,
#endif
    2, 'D', 'B', FCBOP, 0,
#if SIZEOF_OFFSET_T > 2
    2, 'D', 'D', FQBOP, 0,
#endif
    7, '.', 'D', 'E', 'F', 'I', 'N', 'E', EXPORTOP, 0,
    2, 'D', 'W', FDBOP, 0,
    3, 'E', 'N', 'D', PROCEOFOP, 0,
    4, 'E', 'N', 'D', 'B', ENDBOP, 0,
    6, '.', 'E', 'N', 'T', 'E', 'R', ENTEROP, 0,
    5, 'E', 'N', 'T', 'R', 'Y', ENTRYOP, 0,
    3, 'E', 'Q', 'U', EQUOP, 0,
    5, '.', 'E', 'V', 'E', 'N', EVENOP, 0,
    6, 'E', 'X', 'P', 'O', 'R', 'T', EXPORTOP, 0,
    6, 'E', 'X', 'T', 'E', 'R', 'N', IMPORTOP, 0,
    7, '.', 'E', 'X', 'T', 'E', 'R', 'N', IMPORTOP, 0,
    5, 'E', 'X', 'T', 'R', 'N', IMPORTOP, 0,
    4, 'F', 'A', 'I', 'L', FAILOP, 0,
    5, '.', 'F', 'A', 'I', 'L', FAILOP, 0,
    3, 'F', 'C', 'B', FCBOP, 0,
    3, 'F', 'C', 'C', FCCOP, 0,
    3, 'F', 'D', 'B', FDBOP, 0,
    3, 'G', 'E', 'T', GETOP, 0,
    6, 'G', 'L', 'O', 'B', 'A', 'L', GLOBLOP, 0,
    5, 'G', 'L', 'O', 'B', 'L', GLOBLOP, 0,
    5, 'I', 'D', 'E', 'N', 'T', IDENTOP, 0,
    6, 'I', 'M', 'P', 'O', 'R', 'T', IMPORTOP, 0,
    7, 'I', 'N', 'C', 'L', 'U', 'D', 'E', GETOP, 0,
    5, 'L', 'C', 'O', 'M', 'M', LCOMMOP, 0,
    6, '.', 'L', 'C', 'O', 'M', 'M', LCOMMOP1, 0,
    5, '.', 'L', 'I', 'S', 'T', LISTOP, 0,
    3, 'L', 'O', 'C', LOCOP, 0,
#if SIZEOF_OFFSET_T > 2
    5, '.', 'L', 'O', 'N', 'G', FQBOP, 0,
#endif
    8, '.', 'M', 'A', 'C', 'L', 'I', 'S', 'T', MACLISTOP, 0,
    5, 'M', 'A', 'C', 'R', 'O', MACROOP, 0,
    4, '.', 'M', 'A', 'P', MAPOP, 0,
    3, 'O', 'R', 'G', ORGOP, 0,
    4, '.', 'O', 'R', 'G', ORGOP, 0,
    6, 'P', 'U', 'B', 'L', 'I', 'C', EXPORTOP, 0,
    3, 'R', 'M', 'B', RMBOP, 0,
    4, '.', 'R', 'O', 'M', DATAOP, 0,
    5, '.', 'S', 'E', 'C', 'T', SECTOP, 0,
    3, 'S', 'E', 'T', SETOP, 0,
    5, 'S', 'E', 'T', 'D', 'P', SETDPOP, 0,
    6, '.', 'S', 'H', 'O', 'R', 'T', FDBOP, 0,
    6, '.', 'S', 'P', 'A', 'C', 'E', RMBOP, 0,
    5, '.', 'T', 'E', 'X', 'T', TEXTOP, 0,
    5, '.', 'W', 'A', 'R', 'N', WARNOP, 0,
    5, '.', 'W', 'O', 'R', 'D', FDBOP, 0,
    6, '.', 'Z', 'E', 'R', 'O', 'W', BLKWOP, 0,

    /* hardware ops. The opcode field is now used */

    3, 'A', 'B', 'X', INHER, 0x3A,
    4, 'A', 'D', 'C', 'A', ALL, 0x89,
    4, 'A', 'D', 'C', 'B', ALL, 0xC9,
    4, 'A', 'D', 'D', 'A', ALL, 0x8B,
    4, 'A', 'D', 'D', 'B', ALL, 0xCB,
    4, 'A', 'D', 'D', 'D', ALL, 0xC3,
    4, 'A', 'N', 'D', 'A', ALL, 0x84,
    4, 'A', 'N', 'D', 'B', ALL, 0xC4,
    5, 'A', 'N', 'D', 'C', 'C', IMMED, 0x1C,
    3, 'A', 'S', 'L', ALTER, 0x08,
    4, 'A', 'S', 'L', 'A', INHER, 0x48,
    4, 'A', 'S', 'L', 'B', INHER, 0x58,
    3, 'A', 'S', 'R', ALTER, 0x07,
    4, 'A', 'S', 'R', 'A', INHER, 0x47,
    4, 'A', 'S', 'R', 'B', INHER, 0x57,
    3, 'B', 'C', 'C', SHORT, 0x24,
    3, 'B', 'C', 'S', SHORT, 0x25,
    3, 'B', 'E', 'Q', SHORT, 0x27,
    3, 'B', 'G', 'E', SHORT, 0x2C,
    3, 'B', 'G', 'T', SHORT, 0x2E,
    3, 'B', 'H', 'I', SHORT, 0x22,
    3, 'B', 'H', 'S', SHORT, 0x24,
    4, 'B', 'I', 'T', 'A', ALL, 0X85,
    4, 'B', 'I', 'T', 'B', ALL, 0XC5,
    3, 'B', 'L', 'E', SHORT, 0x2F,
    3, 'B', 'L', 'O', SHORT, 0x25,
    3, 'B', 'L', 'S', SHORT, 0x23,
    3, 'B', 'L', 'T', SHORT, 0x2D,
    3, 'B', 'M', 'I', SHORT, 0x2B,
    3, 'B', 'N', 'E', SHORT, 0x26,
    3, 'B', 'P', 'L', SHORT, 0x2A,
    3, 'B', 'R', 'A', SHORT, 0x20,
    4, 'L', 'B', 'R', 'A', LONG, 0x16,
    3, 'B', 'R', 'N', SHORT, 0x21,
    3, 'B', 'S', 'R', SHORT, 0x8D,
    4, 'L', 'B', 'S', 'R', LONG, 0x17,
    3, 'B', 'V', 'C', SHORT, 0x28,
    3, 'B', 'V', 'S', SHORT, 0x29,
    3, 'C', 'L', 'R', ALTER, 0x0F,
    4, 'C', 'L', 'R', 'A', INHER, 0x4F,
    4, 'C', 'L', 'R', 'B', INHER, 0x5F,
    4, 'C', 'M', 'P', 'A', ALL, 0x81,
    4, 'C', 'M', 'P', 'B', ALL, 0xC1,
    4, 'C', 'M', 'P', 'X', ALL, 0x8C,
    3, 'C', 'O', 'M', ALTER, 0x03,
    4, 'C', 'O', 'M', 'A', INHER, 0x43,
    4, 'C', 'O', 'M', 'B', INHER, 0x53,
    4, 'C', 'W', 'A', 'I', IMMED, 0x3C,
    3, 'D', 'A', 'A', INHER, 0x19,
    3, 'D', 'E', 'C', ALTER, 0x0A,
    4, 'D', 'E', 'C', 'A', INHER, 0x4A,
    4, 'D', 'E', 'C', 'B', INHER, 0x5A,
    4, 'E', 'O', 'R', 'A', ALL, 0x88,
    4, 'E', 'O', 'R', 'B', ALL, 0xC8,
    3, 'E', 'X', 'G', SWAP, 0x1E,
    3, 'I', 'N', 'C', ALTER, 0x0C,
    4, 'I', 'N', 'C', 'A', INHER, 0x4C,
    4, 'I', 'N', 'C', 'B', INHER, 0x5C,
    3, 'J', 'M', 'P', ALTER, 0x0E,
    3, 'J', 'S', 'R', ALTER, 0x8D,
    3, 'L', 'D', 'A', ALL, 0x86,
    3, 'L', 'D', 'B', ALL, 0xC6,
    3, 'L', 'D', 'D', ALL, 0xCC,
    3, 'L', 'D', 'U', ALL, 0xCE,
    3, 'L', 'D', 'X', ALL, 0x8E,
    4, 'L', 'E', 'A', 'S', INDEXD, 0x32,
    4, 'L', 'E', 'A', 'U', INDEXD, 0x33,
    4, 'L', 'E', 'A', 'X', INDEXD, 0x30,
    4, 'L', 'E', 'A', 'Y', INDEXD, 0x31,
    3, 'L', 'S', 'L', ALTER, 0x08,
    4, 'L', 'S', 'L', 'A', INHER, 0x48,
    4, 'L', 'S', 'L', 'B', INHER, 0x58,
    3, 'L', 'S', 'R', ALTER, 0x04,
    4, 'L', 'S', 'R', 'A', INHER, 0x44,
    4, 'L', 'S', 'R', 'B', INHER, 0x54,
    3, 'M', 'U', 'L', INHER, 0x3D,
    3, 'N', 'E', 'G', ALTER, 0x00,
    4, 'N', 'E', 'G', 'A', INHER, 0x40,
    4, 'N', 'E', 'G', 'B', INHER, 0x50,
    3, 'N', 'O', 'P', INHER, 0x12,
    3, 'O', 'R', 'A', ALL, 0x8A,
    3, 'O', 'R', 'B', ALL, 0xCA,
    4, 'O', 'R', 'C', 'C', IMMED, 0x1A,
    4, 'P', 'S', 'H', 'S', SSTAK, 0x34,
    4, 'P', 'S', 'H', 'U', USTAK, 0x36,
    4, 'P', 'U', 'L', 'S', SSTAK, 0x35,
    4, 'P', 'U', 'L', 'U', USTAK, 0x37,
    3, 'R', 'O', 'L', ALTER, 0x09,
    4, 'R', 'O', 'L', 'A', INHER, 0x49,
    4, 'R', 'O', 'L', 'B', INHER, 0x59,
    3, 'R', 'O', 'R', ALTER, 0x06,
    4, 'R', 'O', 'R', 'A', INHER, 0x46,
    4, 'R', 'O', 'R', 'B', INHER, 0x56,
    3, 'R', 'T', 'I', INHER, 0x3B,
    3, 'R', 'T', 'S', INHER, 0x39,
    4, 'S', 'B', 'C', 'A', ALL, 0x82,
    4, 'S', 'B', 'C', 'B', ALL, 0xC2,
    3, 'S', 'E', 'X', INHER, 0x1D,
    3, 'S', 'T', 'A', ALTER, 0x87,
    3, 'S', 'T', 'B', ALTER, 0xC7,
    3, 'S', 'T', 'D', ALTER, 0xCD,
    3, 'S', 'T', 'U', ALTER, 0xCF,
    3, 'S', 'T', 'X', ALTER, 0x8F,
    4, 'S', 'U', 'B', 'A', ALL, 0x80,
    4, 'S', 'U', 'B', 'B', ALL, 0xC0,
    4, 'S', 'U', 'B', 'D', ALL, 0x83,
    3, 'S', 'W', 'I', INHER, 0x3F,
    4, 'S', 'Y', 'N', 'C', INHER, 0x13,
    3, 'T', 'F', 'R', SWAP, 0x1F,
    3, 'T', 'S', 'T', ALTER, 0x0D,
    4, 'T', 'S', 'T', 'A', INHER, 0x4D,
    4, 'T', 'S', 'T', 'B', INHER, 0x5D,
    0				/* end of ops */
};

PUBLIC char page1ops[] =
{

    4, 'L', 'B', 'C', 'C', LONG, 0x24,
    4, 'L', 'B', 'C', 'S', LONG, 0x25,
    4, 'L', 'B', 'E', 'Q', LONG, 0x27,
    4, 'L', 'B', 'G', 'E', LONG, 0x2C,
    4, 'L', 'B', 'G', 'T', LONG, 0x2E,
    4, 'L', 'B', 'H', 'I', LONG, 0x22,
    4, 'L', 'B', 'H', 'S', LONG, 0x24,
    4, 'L', 'B', 'L', 'E', LONG, 0x2F,
    4, 'L', 'B', 'L', 'O', LONG, 0x25,
    4, 'L', 'B', 'L', 'S', LONG, 0x23,
    4, 'L', 'B', 'L', 'T', LONG, 0x2D,
    4, 'L', 'B', 'M', 'I', LONG, 0x2B,
    4, 'L', 'B', 'N', 'E', LONG, 0x26,
    4, 'L', 'B', 'P', 'L', LONG, 0x2A,
    4, 'L', 'B', 'R', 'N', LONG, 0x21,
    4, 'L', 'B', 'V', 'C', LONG, 0x28,
    4, 'L', 'B', 'V', 'S', LONG, 0x29,
    4, 'C', 'M', 'P', 'D', ALL, 0x83,
    4, 'C', 'M', 'P', 'Y', ALL, 0x8C,
    3, 'L', 'D', 'S', ALL, 0xCE,
    3, 'L', 'D', 'Y', ALL, 0x8E,
    3, 'S', 'T', 'S', ALTER, 0xCF,
    3, 'S', 'T', 'Y', ALTER, 0x8F,
    4, 'S', 'W', 'I', '2', INHER, 0x3F,
    0				/* end of page 1 ops */
};

PUBLIC char page2ops[] =
{
    4, 'C', 'M', 'P', 'S', ALL, 0x8C,
    4, 'C', 'M', 'P', 'U', ALL, 0x83,
    4, 'S', 'W', 'I', '3', INHER, 0x3F,
    0				/* end of page 2 ops */
};


/* --- end of keywords --- */
