/* rom.ld - bcc09 -Mr's linker script: a Color BASIC ROM cartridge, for
   the CoCo and the Dragon.  The code, and an image of the initialized
   data, are in the cartridge's ROM at $C000 (up to $FEFF); the data and
   BSS are in RAM from $0600 (after the text screen), where crtrom.o
   copies the data; the stack is below __stack_top, $8000 for a 32K
   machine (ld09 -A __stack_top=0x4000 for 16K).  The output is the ROM's
   image, 8K or 16K.  To change the layout, copy this, change it, and link with
   bcc09 -X-S and the copy.

   Written for bcc09.  Like the rest of libc, it is distributed under the
   GNU Library General Public License, version 2 (see COPYING.LIB). */

OUTPUT_FORMAT(binary)

MEMORY
{
    ROM (rx) : ORIGIN = 0xC000, LENGTH = 0x3F00
    RAM (rw) : ORIGIN = 0x0600, LENGTH = 0x7A00
}

SECTIONS
{
    /* crtrom.o's code first: the cartridge starts at $C000 */
    .text :
    {
        crtrom.o(LOC0)
        *(LOC0 LOC1)
    } > ROM

    /* segment 5, the init functions, in a statement of its own */
    .data :
    {
        *(LOC2 LOC3 LOC4)
        *(LOC5)
        *(LOC6 LOC7 LOC8 LOC9 LOC1?)
        __edata = .;
    } > RAM AT> ROM

    /* (crtrom.o clears from __edata to __end; the heap starts at __end:
       defined here, since what ld09 would provide reaches .fill) */
    .bss (NOLOAD) :
    {
        *(COMMON)
        __end = .;
    } > RAM

    /* the image filled out to an EPROM's size: 8K ($C000-$DFFF), or 16K
       less the last page ($C000-$FEFF: $FF00 up is I/O) */
    .fill :
    {
        . = . <= 0xE000 ? 0xE000 : 0xFF00;
    } > ROM = 0xFF

    PROVIDE(__stack_top = 0x8000);
}
