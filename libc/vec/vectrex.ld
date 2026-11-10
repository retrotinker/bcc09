/* vectrex.ld - bcc09 -Mv's linker script: a Vectrex cartridge.  The
   header (segment 12: __vec_header's module) is at $0000, crtvec.o's
   code after it, then the rest of the code and an image of the
   initialized data, in the cartridge's ROM (up to 32K); the data and
   BSS are in the Vectrex's RAM from $C880, after the BIOS's variables,
   where crtvec.o copies the data; the stack is below __stack_top,
   $CBEA, where the BIOS's own is.  The output is the ROM's image.  To
   change the layout, copy this, change it, and link with bcc09 -X-S and
   the copy.

   Written for bcc09.  Like the rest of libc, it is distributed under the
   GNU Library General Public License, version 2 (see COPYING.LIB). */

OUTPUT_FORMAT(binary)

MEMORY
{
    ROM (rx) : ORIGIN = 0x0000, LENGTH = 0x8000
    RAM (rw) : ORIGIN = 0xC880, LENGTH = 0x036A
}

SECTIONS
{
    /* the header, then crtvec.o's code, which the BIOS runs after it */
    .text :
    {
        *(LOC12)
        crtvec.o(LOC0)
        *(LOC0 LOC1)
    } > ROM

    /* segment 5, the init functions, in a statement of its own */
    .data :
    {
        *(LOC2 LOC3 LOC4)
        *(LOC5)
        *(LOC6 LOC7 LOC8 LOC9 LOC10 LOC11 LOC13 LOC14 LOC15)
        __edata = .;
    } > RAM AT> ROM

    .bss (NOLOAD) :
    {
        *(COMMON)
        __end = .;
    } > RAM

    PROVIDE(__stack_top = 0xCBEA);
}
