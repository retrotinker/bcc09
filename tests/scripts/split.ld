/* split.ld - a C program's code at $0E00, and its data and BSS at
   $6000: ld09 provides the symbols libc's start-up code needs (__edata,
   __end, and __seg5DL and __seg5DH around the init functions, which
   must be in one place: a statement of their own) */
SECTIONS
{
    .text 0x0E00 : { *(LOC0 LOC1) }
    .data 0x6000 :
    {
        *(LOC2 LOC3 LOC4)
        *(LOC5)
        *(LOC6 LOC7 LOC8 LOC9 LOC1?)
        *(COMMON)
    }
}
