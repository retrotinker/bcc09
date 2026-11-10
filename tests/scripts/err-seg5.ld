/* err-seg5.ld - the init functions (segment 5) split between two
   sections, so __seg5DL and __seg5DH can't be provided */
SECTIONS
{
    .text 0x0E00 : { *(LOC0 LOC1) *xfptvc.o(LOC5) }
    .data 0x6000 : { *(LOC2 LOC3 LOC4 LOC5 LOC6 LOC7 LOC8 LOC9 LOC1?) *(COMMON) }
}
