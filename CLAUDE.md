# bcc09: project notes

**Keep this file current.** Whenever a change alters anything below
(version, layout, commands, test counts, behavior, decisions, open
items), update this file in the same branch.

C compiler, preprocessor, optimizer, assembler, linker, librarian and binary utilities for the Motorola
MC6809 (the Tandy Color Computer, and Dragon, etc), derived from the MC6809 configuration of tools from
Bruce Evans' C compiler (dev86). GitHub: `retrotinker/bcc09`.

## Project Goals

- bug fixes & cleanups
- port of the dev86 libc directory, including libc/bcc implementation for all integer types
- RPM packaging suitable for Fedora
- create a doc directory
  - create man pages for all of the generated exectuables
  - create a PDF User's Manual for the project

## Layout

- `ld/` builds `ld09` (linker), `objdump09` (also installed as `nm09` and `size09`) and
  `objcopy09` (`objcopy.c`, `srec.c`). objcopy09 writes binary, srec, ihex, cas, wav,
  decb, ddos and os9 output. `objcopy01` in `retrotinker/mc6801-tools` is derived from it;
  bug fixes made there should be brought back here.

## Known issues

- With GCC 15 and later (C23 default), the K&R code in `bcc/`, `cpp/`, `ld/` and `unproto/`
  fails to build. `make CC="gcc -std=gnu89"` works around it. `cpp/` also needs `gperf`.
