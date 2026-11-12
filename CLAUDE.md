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
  - create a PDF for the bcc09 tools, inspired by "CMOC for BASIC Programmers"
- support linker scripts for ld09
  - control object inclusion, ordering, and placement in memory
  - define symbols and entry points
  - meet or exceed the linker script functionality in the mc6801-tools project
- verify copt/rules.6809 and expand appropriately
- target CoCo BASIC, OS-9, FLEX, and Vectrex
- floating point support should be optional
- add stdint.h and stdbool.h to libc
- update README.md to reflect current project status

## Layout

- Version 0.14.0 (released 2026-11-11; `VERSION` in the Makefile, and `bcc09.spec`);
  0.8.0 (2026-11-09) was the first release since v0.1 (2014), then 0.9.0, 0.10.0,
  0.11.0, 0.11.1, 0.11.2, 0.12.0, 0.13.0, 0.13.1, 0.13.2, 0.13.3 and 0.13.4. 0.9.0 and
  later have a
  GitHub release with the RPMs (bcc09, bcc09-doc) and source RPM attached (`gh release create`).
  The PDF manuals are in the noarch subpackage `bcc09-doc` (since 0.11.2-2), which
  `bcc09` Recommends (same version-release; 0.11.2-3), so dnf installs it unless told not
  to; the rpmlintrc's FSF-address filter covers its license directory too. `make rpm`/`make srpm` (added 2026-11-09) build Fedora
  packages in `rpmbuild/` from `git archive` of the tag `v$(VERSION)` (HEAD while it
  isn't tagged), as plm09's do; the spec builds with `PREFIX=/usr`, runs `make check`
  in `%check`, and its License follows Fedora's dev86 (adding LGPL-2.0-only for bcc09's
  libc files and SunPro for fdlibm). `bcc09.rpmlintrc` filters what rpmlint says of a
  cross toolchain's 6809 files. `PREFIX` is `/usr/local` by default (2026-11-10; it was `/usr/local/bcc09`, and the
  sub-Makefiles' own defaults, `/usr` and `/usr/local/bcc09`, are `/usr/local` too):
  bcc09 compiles it in, so `make` and `make install` need the same one; nothing installed
  clashes (all `*09`, passes in `libexec/bcc09`, `bcc09-*` pages). ld09's built-in
  library directory stays dev86's `/usr/local/lib/m09/` (nothing there; searched after
  every `-L`, and the driver always gives one): `share/bcc09` there would let a link
  that can't find a library (in the tests, say) take an installed one instead.
  libc, the start-up files and the headers are in `$(PREFIX)/share/bcc09` (moved from
  `lib/bcc09` 2026-11-09, for the package: they are no host's code), for every install
  and the tests' prefixes alike, since the compiler's output names the headers' paths. Every install takes `DESTDIR`; every Makefile takes
  `CFLAGS`/`LDFLAGS` from the environment (rpmbuild's) and adds what it needs
  (`ALL_CFLAGS`), and nothing is stripped at link time (rpmbuild strips). The top-level Makefile passes
  `VERSION` to the sub-makes, and `bcc09 -v` (with no files), `as09 -v` and `ld09 -v`
  print it (added 2026-11-09). A release bumps `VERSION`, the spec (with a `%changelog`
  entry), README's heading and every man page's `.TH` (`tests/man.sh` checks that they
  name `VERSION`), runs `make docs`, and tags `vX.Y.Z` (`-m "bcc09 X.Y.Z"`).
- `ld09` writes whole symbol names into an executable (8 characters in each a.out entry,
  the rest in entries after it): its `-y`, the default since 2026-11-08 (`-y-` for the old
  8-character names); `objdump09 -n` joins them.
- `ld/` builds `ld09` (linker), `objdump09` (also installed as `nm09` and `size09`) and
  `objcopy09` (`objcopy.c`, `srec.c`). objcopy09 writes binary, srec, ihex, cas, wav,
  decb, ddos, os9 and flex (FLEX .CMD; added 2026-11-09) output. Data linked apart from the
  code, above it or below (`-D`): srec, ihex, decb and flex write each part at its
  address; binary, cas, wav and ddos are one block, so `-p` (`flatten()`, added
  2026-11-11) makes one image in a temporary file, from the lower address to the end
  of the higher, zeros between (overlap, or more than 64K, an error); without it cas,
  wav and ddos refuse, saying so. `-p` with the data below used to seek back from the
  start and write a 4 GB (sparse) file. `prog-L` (-T0x4000 -D0x1000) tests it; a
  low-data `-Me` program from a `-p` cassette ran in XRoar. `objcopy01` in `retrotinker/mc6801-tools` is derived from it;
  bug fixes made there should be brought back here.
- ld09's linker scripts (`-S`, `-A`, `-P`, `-Z`; added 2026-11-09) are ld01's
  (mc6801-tools): `ld/script.c`, and `writex86.c`'s layout driven by it, brought over
  whole; fixes to either should go to the other. ld09 keeps its own ways: hexadecimal
  `-T`/`-D`/`-H`, its default library directory, A_M6809, and its layout, which the
  default script (`ld09 -P`) gives byte for byte: ld01 1.6's (counters 0 and 1 in the
  text; 2 in one page, then 3 to 15, in the data; each module's part padded to 4, common
  blocks rounded to 4), not 2.0's (no `.bss` = LOC4: as09's `.BSS` is counter 3). Left
  out: ld01's page-zero check of one-byte relocations (the 6809's DP makes any page
  right). ld01's import-counter rule came over 2026-11-11 (`BAREIMPORT`, `DEFINES`,
  `import_counter()`): a bare import under another segment than its definition, common
  block (as ld01 has it since mc6801-tools PR 73) or absolute value, is satisfied by
  it whichever comes first, with a warning unless absolute; before, with the import
  read first, the symbol was undefined. The direct page's error (`direct_import()`)
  is checked first. `imp-ab`/`imp-ba`, `comm-seg`/`comm-seg2` test it. Beyond ld01: where a script doesn't assign
  them, ld09 provides `__btext`, `__etext`, `__bdata`, `__edata` and `__end` from the
  a.out layout (always in the symbol table, for objcopy09) and, if imported,
  `__segnDL`/`DH`/`CL`/`CH` from where segment n's input went (an error if it isn't in
  one place), so a script needs nothing for libc's start-up code but segment 5 in a
  statement of its own. The driver passes `-X-S...`, `-X-A...` and `-X-Z` quietly.
- dev86's x86 leftovers removed (2026-11-11): ld09's `DATASEGS` (always defined; its
  `#ifndef` hid an x86 "intersegment jump" check, `interseg()`), `ld/objchop.c` and
  `ld/catimage.c` (ELKS image tools, built, never installed), and ar09's `__.SYMDEF`
  code (GNU a.out symbols, which as09's objects never had: the table was always empty;
  ld09 reads every member), with `ld/rel_aout.h` (only that used it; `ld/x86_aout.h` is
  the one a.out header now) and `ar/alloca.c`. ar09's `s` is accepted and ignored;
  alone, it only checks the archive is there (`arops.result`). `etextpadoff` was
  already gone. ld01 has `DATASEGS` too. Then a survey (2026-11-11) of what dev86 left:
  bcc09's `-z` (ld86's x86 zero page) and `-Q` (to cc1, which has none) went, cpp's
  `-0`/`-3` (x86 macros) went and its `-f` defines `__FIRST_ARG_IN_X__`, cc1's
  inline-assembly `outbyte()`/`outstr()` (for cc1 built by bcc) went, and the MS-DOS, EDOS
  and Minix host code. Every program's options match its man page (`tests/man.sh`); TODO's
  "removing unused options" and "x86-isms" items are done.
- `cpp/token1.h` and `cpp/token2.h` are generated by `gperf` from `token1.tok` and
  `token2.tok`, and are checked in so that building does not need gperf. After changing a
  `.tok` file, run `make -C cpp tokens` (needs gperf 3.1 or later, which uses `size_t`
  lengths).
- `libc/` builds `libc.a` and each target's start-up file and library, installed in
  `$(PREFIX)/share/bcc09` (headers in `include/` there), so `bcc09 -o prog -X-T0x3000
  prog.c` builds a whole program. libc has the 16- and 32-bit run-time helpers
  (`libc/bcc/`), `string.h`, `ctype.h`, `stdlib.h` with `malloc`, `stdarg.h` and `stdio.h`
  (dev86's `FILE` layer, and new `printf` and `scanf` families that match glibc); mostly
  dev86's C, compiled by `bcc09` itself. Floating point (started 2026-11-08) is IEEE 754
  single and double, big-endian, in software: the helpers `cc1` calls are in
  `libc/bcc/fp*.s` (round to nearest even, denormals, infinities, NaNs; results must equal
  the host's). `printf`'s `%e`/`%f`/`%g`/`%a`, `strtod`/`atof` and `scanf`'s `%a`/`%e`/`%f`/`%g`
  are exact, like glibc's, from big integers (`libc/stdlib/bignum.c`), and optional:
  `cc1` makes a module that passes floating point to a `*printf` (a pointer to it to a
  `*scanf`) refer to `__xfpcvt` (`__xfptvc`), whose modules (`libc/stdio/xfp*.s`) install
  the code through an init function, so programs without floats don't carry it (decided
  2026-11-08). `%a` (added 2026-11-10: `hexfp()` in `fpfmt.c`, about 950 bytes) is
  glibc's: leading 1, or 0 with `p-1022` for denormals, rounded to even, which can make
  it `0x2p+0`. `math.h` (C89's functions, and `copysign`, `scalbn`, `expm1`, `finite`) is Sun's fdlibm 5.3 in `libc/math/` (its `README` lists
  the changes: `__i32` for fdlibm's 32-bit ints, big-endian `__HI`/`__LO`, `errno` as
  glibc sets it), in `libc.a`, a module per function.
  A double argument is always passed on the stack (even the first); a double result is in
  D, X, Y, U (in that order in memory), a float result in D:X; the helpers keep Y and U.
  `libc/README` gives the calling conventions and the changes from dev86.
- Start-up: `crt0` clears the BSS, calls the init functions (addresses a module puts in
  segment 5: `loc 5`; zeros, the linker's padding, are skipped), and calls `main`; when
  `main` returns, `exit()` runs the
  `atexit()` functions and the target's `_exit()`. The heap grows from `__end` up to the
  stack pointer minus `__heap_margin` (256 bytes; decided 2026-11-08), which
  `sbrk()`/`brk()` enforce.
- Targets (decided 2026-11-08): `libc.a` is target-independent; each `-M` target has a
  start-up file and a library (`_exit`; `read`, `write`, `close`, `lseek`, `isatty`, `open`
  where it has I/O) that the driver links:
  - `-Ms` → `crt0.o` + `libsa.a`: returns to its loader; no I/O.
  - `-Me` → `crt0.o` + `libcb.a`: Color BASIC `EXEC` programs, with I/O through the
    ROM's POLCAT/CHROUT vectors (the Dragon's are the same), with no newline
    translation (decided 2026-11-09: a line ends with `'\r'`, both ways); tested with a stand-in ROM
    (`tests/src/cbrom.s`) by `make check`, and on real ROMs in XRoar by
    `make check-xroar`. Disk BASIC's files (added 2026-11-09; CoCo only, not DragonDOS):
    `libc/cb/disk.c` does RS-DOS's FAT and directory itself on DSKCON (`cb/dskcon.s`),
    and `open()` sets the hook (`__cb_files`, `cb/cb.h`) that `read`/`write`/`lseek`/`close`
    use for descriptors 3 up, so programs without files don't carry it.
  - `-Mi` → `crtsim.o` + `libsim.a`: sim6809, for the tests.
  - `-Mr` → `crtrom.o` + `librom.a` + `rom.ld` (added 2026-11-09): a ROM cartridge for
    the CoCo 1/2 and the Dragon, started at $C000 by BASIC's FIRQ handler (probed in
    XRoar: all enter at $C000; the CoCo 3 enters before BASIC is set up, with S 0 and no
    CHROUT vector, so no I/O there). The driver passes `-S` with `rom.ld` from the
    library directory unless the command has a `-S`. `rom.ld`: code and the data's
    image in ROM from $C000, filled with $FF to 8K or $FF00 (XRoar takes a file's size
    mod 256 as a header to skip); data, BSS, heap in RAM from $0600; `__stack_top`
    $8000 (`-A` to change); it defines `__edata`/`__end` itself (ld09's would reach the
    fill section). `crtrom` masks interrupts, turns off the CART FIRQ ($FF23 bit 0),
    copies `__data_load` to `__data_start`..`__data_end`; `librom.a` is libcb's objects
    with `rom/_exit.s` (stops in a loop), not libcb's `_exit` (an `_exit` in the crt
    made ld09 warn of a redefinition on every link). Defines `__CB__` and `__CBROM__`.
  - `-Mo` → `crtos9.o` + `libos9.a` (all of libc built again with `-Mo`, in `os9obj`):
    OS-9 program modules (below).
  - `-Mf` → `crtflex.o` + `libflex.a` (added 2026-11-09): FLEX commands
    (`objcopy09 -O flex`), stack moved to `MEMEND`, argv from the line buffer (argv[0]
    the word before LPOINT, which real FLEX leaves past the name's blank, so
    `P,PROG` gives `PROG`), I/O through `INCH`/`PUTCHR` with no newline translation
    (lines typed end with CR; FLEX's terminal wants CR LF), exit through `WARMS` with
    B (sim6809's exit status) after FMSCLS. Files (`flex/file.c`, added 2026-11-09)
    through FMS: text (space compression) or `O_BINARY` (`"b"`), write only into new
    files (`O_TRUNC` deletes first; no `O_RDWR`/`O_APPEND`), `lseek()` for reading only,
    `unlink`, `rename`. Real FLEX's rewind makes an FCB text again, and delete puts `$FF`
    in its name: `file.c` and sim6809 both allow for it.
  - `-Mv` → `crtvec.o` + `libvec.a` + `vectrex.ld` (added 2026-11-09): a Vectrex
    cartridge. `vectrex.ld`: the header (segment 12, `*(LOC12)`) at $0000, then
    `crtvec.o(LOC0)` (the BIOS runs the code after the header), code and the data's image
    in ROM; data and BSS in RAM $C880-$CBEA (the BIOS's variables are below, its stack
    area above), stack at `__stack_top` $CBEA. `crtvec` sets S and DP $D0, copies data,
    clears BSS, init functions, main; it imports `__vec_header` in segment 12 (ld09
    matches an import with a definition in the same segment only), which links libvec's
    default header ("BCC09") or a program's own module (`vectrex.h` shows one, in C
    with a file-scope `asm()`; or `vectitle.s`; no warning, since the ld09 change).
    cc1 forgets which segment it is in after assembly code outside a function
    (`asmseg()`, 2026-11-11: a header's `loc 12` had put the next data in it;
    `asmseg.c`); inside a function, the asm must put it back. Print_Ships's ship is
    character $68 ($6E is a striped block). libvec: `_exit` (stops), wrappers
    named as the BIOS routines (`Wait_Recal`, `Moveto_d(y, x)`, `Print_Str_d(y, x, s)`
    with `\200`-ended strings...; addresses from the common VECTREX.INC, written fresh:
    the gcc6809 tutorial's `vectrex.h` is GPLv3), each setting DP $D0 ($C8 for
    `Init_Music_chk`); as09's `INCLUDE` is relative to the current directory, so each
    module has its own equates. No read/write, so no stdio. Defines `__VECTREX__`.
    More of the BIOS (2026-11-11), each routine's conventions read off the BIOS itself
    (traced on sim6809 with the image, and checked in MAME): `Intensity_1F/3F/5F/7F`,
    `Moveto_d_7F` (draw.s); lists.s: `Draw_VL_a` (A = lines - 1), `Draw_VLcs` (count,
    scale, lines), `Draw_VLp` (pattern, y, x; a positive pattern ends it, so dashes are
    negative), `Mov_Draw_VL_a` (a move, then A lines), `Draw_Pat_VL_a` (Vec_Pattern),
    `Dot_List` (Vec_Misc_Count + 1 dots), `Rot_VL_ab` (64 to a turn, anticlockwise:
    16 takes 0,64 to 64,0); text.s: `Print_Str_yx`, `Print_List` (U; ends at a y of
    0), `Print_Ships`; score.s (no DP: they jump): `Clear_Score`, `Add_Score_a`
    (binary, to 99), `Add_Score_d` (BCD), `New_High_Score`; input2.s (apart from
    input.s, so programs that don't call them don't carry them): `Read_Btns_Mask`
    (Vec_Btn_State &= mask, then Read_Btns), `Joy_Analog` (DEC Vec_Misc_Count into
    Joy_Digital), `Select_Game` (A players, B games; Vec_Num_Players/Game from 1,
    ends by itself); sound2.s: `Sound_Byte` (A reg, B value, copy at $C800+reg),
    `Sound_Bytes` (U pairs to a negative reg), `Clear_Sound` (the BIOS's leaves
    registers 13-0 at 1, not 0, its Sound_Byte returning B 1, and the music
    buffer's mixer $3F: silent after Do_Sound), `Explosion_Snd` (DP $C8, U the 4
    bytes; Vec_Expl_Flag $80 starts one); `Music1`-`MusicD` in vectrex.h.
    `vecbios.s` stands in for each (its routines at $F940 now, past $F92E; the fixed
    intensities, `Print_Str_yx`, `Read_Btns_Mask` and `Joy_Analog` fall into the
    routines after them as the BIOS's do); `veclist.c` calls each; `xvec.c` uses
    them in MAME, `results[7]` $113F: bits for the score, the high score, a rotation,
    the sound (Sound_Byte's copy, Clear_Sound's mixer), the explosion's end, and
    Select_Game's 1 player, game 1 (high byte) on the real BIOS.
    `doc/rocks.c` (2026-11-11; in bcc09-doc) is an example game (asteroids: turn,
    thrust, fire; 8.8 positions whose high bytes wrap the screen; 2K): `make check`
    builds it (`rocks.img`, its header from `asm()`), and `check-vectrex` plays it
    with `rocks.lua` (MAME's `:BUTTONS` and `:CONTR1X`/`Y` fields; shoot 1500
    frames, crash to GAME OVER, restart: `expected-rocks`, deterministic).
  - The others (`-Mu`, `-Mb`) can't link yet (`notarget` uses `-Mu`).
- OS-9's data model (begun 2026-11-08): `-Mo` passes `cc1 -u`, which is `-p`
  (position-independent code: functions and string constants `,PCR`, calls `LBSR`) with
  data through U (`name,U`, linked as offsets: `isdata()` in `genloads.c`); U is then no
  register for values (`codeinit()`), a double result goes through the common `__dret`
  (`dretsym()`, `dretcopy()`), and `?:` and misplaced arguments of doubles are moved on
  the stack (`dblplace()`), since D, X, Y and U can't hold one. Plain `-p` keeps data
  PC-relative (code and data move together). A static initializer that holds an
  address becomes code in an init function (`dumpinits()` in `loadexp.c`). The driver
  links with `ld09 -i` (data at 0); `objcopy09 -O os9` makes the module (`-d`: the stack,
  1K by default), whose `crtos9` copies the data, clears the BSS, runs the init
  functions and passes `argv` from the parameters. `libc/os9/sys.c` has the system
  functions (`read`/`write` through `I$ReadLn`/`I$WritLn`, with no newline translation:
  decided 2026-11-09, OS-9's lines end with CR; files; `unlink`). `run.sh`
  runs `-Mo` code under `simcrt0.s` with U 0, and modules under `sim6809 --os9`
  (`os9io.c`, `os9dir.c`, `os9path.c`, and nine programs that must run as with `-Mi`: `os9.result`),
  and `make check-nitros9` runs the same twelve on real NitrOS-9 Level 2 (all the same, since
  2026-11-09). The heap grows after the data area with `F$Mem` (`os9/sbrk.c`; crt0
  keeps `__dbase`/`__dtop`), and the stack has the data area's rest (`objcopy09 -d`).
  TODO's "HEAPSTART in the environment" (2014, from before libc, beside two os9copy items
  objcopy09 settled) was dropped 2026-11-11: crt0 keeps the data area's bounds and
  `sbrk()` grows the heap, so nothing needs telling where it starts (`sbrk(0)` gives its end).
  `mkdir`, `chdir`, `opendir`/`readdir`/`rewinddir`/`closedir` (`sys/stat.h`,
  `dirent.h`; added 2026-11-09). Every call clears the registers it doesn't set
  (`OS9_CLEAR`): garbage in them made `I$MakDir` take nearly a whole disk. `rmdir` and
  `getcwd` (added 2026-11-10; OS-9 has no calls for them) do what `deldir` and `pwd` do,
  as probed on NitrOS-9 Level 2: I$Delete of a directory gives E$FNA (214) until its D
  attribute is off (I$SetStt SS.Attr $1C, attributes in X; it then can't be opened with
  DIR.), so `rmdir` checks it's empty first (RBF would orphan its files), clears D and
  deletes; `getcwd` walks up `..` matching each `.` LSN in the parent until `..` and `.`
  agree (the root), then `/` and SS.DevNm's name (`D1`, bit 7 ending it). sim6809 1.2.0
  emulates these (made for it: start directory = root of device `H0`, inode LSNs);
  `os9path.c` runs on both and prints paths without the device, so one reference fits.
- Floating point made faster (2026-11-10; `tests/fpbench.sh` times each operation on
  sim6809 with `--cycles`: double + 1706 cycles, * 4265, / 8075; float + 2470, * 3202,
  / 8802, from 2293, 5000, 14183, 5443, 7884 and 17303): `__fpf2d`/`__fpd2f` in
  `fpcore.s` convert normal floats and doubles on their bits (the rest through
  records), so float arithmetic, done in double, costs little more; unpacking and
  packing a double shift the mantissa as they copy it; add shifts the smaller operand
  instead of swapping records; `__fprsh` of 64 bits or more leaves just the sticky bit;
  multiplication leaves out trailing bytes of 0 (a float's: 9 byte products, not 49)
  and runs each row through an unrolled `mrow`, entered by length (`leax mrow,pc`, for
  `-Mo`); division makes 55 quotient bits, from 7-byte mantissas (an unpacked
  record's last byte is 0, which `__fpmul`/`__fpdiv` rely on: only `arith` calls
  them), collected a byte at a time. 458 bytes more code. Tried and dropped: division
  against 8 pre-shifted divisors (1000 cycles less, 80 bytes more stack: the
  Vectrex's RAM is 874 bytes). A random stress check against the host's arithmetic
  (12,000 cases, -Mi and -Mo) found nothing `fptest` doesn't; `gen-fpdata.py` gained
  short-mantissa products and conversion ties decided by the last bit.
- Next: see TODO.
- Licensing: `libc/` is under the GNU Library GPL v2 (`libc/COPYING.LIB`), because it is
  linked into users' programs; the rest of bcc09 is GPL. Every libc source carries a
  notice saying so; new libc files should too, and code with no stated license (such
  as dev86's old `strcspn.c`) shouldn't be copied in. `doc/rocks.c` and `doc/worm.c`,
  the example games, are under the ISC license (decided 2026-11-11), so that a game
  can start from them; the spec's `bcc09-doc` adds `AND ISC` to `%{bcc09_license}`.
- `unproto` is built with `_PROTO_` too (added 2026-11-08): after every `()` it writes for a
  prototype (declarations, function pointer types, casts, typedefs, parameters), and
  after a prototyped heading's argument names, it writes `__proto(type name, ...)`, which
  `cc1` parses (`declproto()`) into the function type (`typestruct.proto`: `functype()`
  shares a type only between equal prototypes; `funcmerge()` makes a prototype and an
  old-style declaration compatible); a call, by name or through a pointer, converts each
  argument to its parameter's type and then promotes it as usual, so the old-style
  definitions `unproto` makes get what they expect, and a wrong number of arguments is an
  error.
- `unproto` is built with `_VA_ALIST_` (`unproto/Makefile`), so the definition of a
  function with `...` gets an `int __va_alist` parameter in its place, whose address
  `libc/include/stdarg.h`'s `va_start` uses (the first argument is in a register, so the
  last named parameter can't be used). No `varargs.h`.
- With a 16-bit `int`, a decimal constant over 32767 is a `long` (C's rules): tests
  that also run on the host must say `40000U` where they mean an `unsigned int`.
- `copt` is the peephole optimizer that `bcc09 -O` runs with `copt/rules.6809` on the
  assembly. A rule's lines match consecutive instructions (comments are skipped, and
  dropped from a match; a label ends one); `%(expr)` is arithmetic, and a rule with an
  expression that isn't a number (a symbol's offset) doesn't apply. A rule can't
  replace lines with nothing: an empty replacement ends the reading of the rules. The
  rules (checked 2026-11-08, and every rule again 2026-11-10) favor size: `LDD #0`
  becomes `CLRA`/`CLRB` (a byte smaller, a cycle slower), only before instructions that
  don't read C; adjacent `LEAS n,S` are merged. Added 2026-11-10, from counting the
  sequences in libc's and the tests' `-O` assembly (each exact: registers, flags and
  stack the same): `CLRA;CLRB;LDX #0` → `TFR D,X` last; a value stored over a just-pushed
  D is pushed instead (`PSHS D` and `PSHS D,...`: `D%1` would match DP); a second
  `CLRA;CLRB` after `STD`; `PSHS D,X,U,Y;PULS D,X,U,Y` goes. libc 499 bytes smaller (of
  143K). cc1's output has none of the classic redundancies (a test after a load, a
  branch over a branch, TFR pairs); what's left needs to know which registers are live,
  or whether two stack offsets overlap, which copt can't. Added 2026-11-11: bcc09 runs copt
  with `-b4` (it passed none, so copt never looked back after a replacement, and a rule
  never saw what an earlier one had made, e.g. the CLRA, CLRB the LDD #0 rule makes), and
  copt's backing up counts only lines that aren't comments (cc1's `-S` output has a
  source line and `;BCC_EOS` between instructions); new rules: a second CLRA, CLRB after
  `PSHS D` (as after STD), `LDD #n` after `LDD #n; PSHS D`, and an unreachable BRA, LBRA or
  JMP after RTS, `PULS ...,PC` or another BRA (cc1's jump over the else after a return).
  libc 349 bytes smaller (57295 to 56946 of its code). Counted with scripts over libc's
  and the tests' `-O -S` output: nothing else common is exactly removable.
  or whether two stack offsets overlap, which copt can't. The store/load rules take
  every address for memory (no `volatile`): the copt man page says so.
- `doc/basic.md` is "bcc09 for BASIC Programmers" (added 2026-11-10): C taught from Color
  BASIC, chapter by chapter, with `coco.h`; `make docs` (`doc/mkbasic.sh`) makes
  `doc/basic.pdf`, committed and packaged. `tests/run.sh` compiles and links every
  complete program in it (a ```c block with `main()`: `basic.result`), so change the
  guide's programs with the library. It is original text, not CMOC's guide's.
  Its chapter "A game" describes `doc/worm.c` (2026-11-11; in bcc09-doc): a worm on
  the text screen, semigraphic blocks `poke`d and `peek`ed (the screen is the board),
  one `inkey()` a move, a ring of positions indexed by `unsigned char`, a delay loop
  (32 cycles a turn: 3500 at the start). `make check-xroar` plays it on the four
  machines: `-type` gives one key per POLCAT call, so per move ('.' no turn, `\n`
  down, `\b` left); two foods, the wall, ENTER, BREAK, BREAK; the board at the 47th
  `inkey` (`xrscreen.py -g` shows blocks as colour digits) and the exit screen
  (`expected-worm`). `make check` runs it under cbrom.s (`worm.run`: the text it
  prints), but that POLCAT's every-other-call "no key" makes only even moves turn, so
  the worm can't reach the food there (a parity: odd columns, even rows).
- `doc/vectrex.md` is "bcc09 for Vectrex Programmers" (added 2026-11-11): C on the
  Vectrex for those who know its BIOS and 6809 assembly (the cartridge's layout, the
  header in C, types and `signed char`, `-S` output, `__direct` in page $C8 (more than
  128 bytes move to $C9), the wrappers and their registers, a call's cost (counted:
  `Moveto_d` about 90 cycles over assembly), frames, controls, sound, RAM (874 bytes;
  constant tables in the ROM with `asm("loc 0", ...)`), speed, assembly modules, rocks.c,
  MAME). `make docs` (`doc/mkvectrex.sh`) makes `doc/vectrex.pdf`, committed and in
  bcc09-doc. `vecdoc.result` compiles each ```c block (with `main()`: linked `-Mv`;
  else `-c`) and assembles each plain block that starts with `;`. Every program in it
  was also run in MAME and looked at; do that again when changing one.
- `doc/os9.md` is "bcc09 for OS-9 Programmers" (added 2026-11-11): C for OS-9 and
  NitrOS-9 (a module: objcopy09, toolshed's `os9 copy`/`attr`/`ident`; code PIC, data
  through U, static pointers set by init functions, `__direct`; argv and the exit
  status; CR lines and `getdelim(..., '\r', ...)`; files (a new file is PR W R, the mode
  ignored), directories; the data area, `-d`, the heap through F$Mem (Level 1: don't
  count on malloc); system calls of one's own in assembly with as09's `OS9`, its
  example `os9time` (F$Time)/`os9sleep` (F$Sleep) keeping U; what libc lacks: time,
  getenv, signals, F$Fork). `make docs` (`doc/mkos9.sh`) makes `doc/os9.pdf`, in
  bcc09-doc. `os9doc.result` assembles its assembly and compiles each ```c block,
  linking those with `main()` (with the assembly) as `-Mo`. Its programs were run under
  sim6809 --os9 and all of them (the clock too) on NitrOS-9 in XRoar (2026-11-11);
  do that again when changing one.
- `doc/flex.md` is "bcc09 for FLEX Programmers" (added 2026-11-11): a command
  (`-X-T0x1000`, objcopy09 -O flex; hello 4431 bytes, with write() 755), start-up and
  WARMS (no exit status; sim6809's), argv (the word before LPOINT; blanks and
  commas), the terminal (PUTCHR, so P/O; INCH lines, CR LF), files (FMS: names,
  new-file writes, text compression, binary's padding, lseek reading, errno), memory
  (to MEMEND, malloc 256 short of S), FLEX's routines from assembly (PSTRNG, PCRLF
  with `__sysdp`), what isn't there, testing. `make docs` (`doc/mkflex.sh`) makes
  `doc/flex.pdf`, in bcc09-doc; `flexdoc.result` as `os9doc.result`. Its programs ran
  under sim6809 --flex, and all but the name prompt (no typing into FLEX) on
  Compusense FLEX in XRoar, NOTES.TXT the same as sim6809's (2026-11-11).
- The manual's chapter 10, "Questions and answers" (added 2026-11-11; TODO's FAQ), answers
  the questions a newcomer hits: a `-Me` program without `-X-T` is linked at 0 (on
  BASIC's variables), CR line ends, trying programs on sim6809, 16-bit `int` and
  constants, unsigned `char`, which C (C89, `//`, `_Bool`; no declarations after
  statements, none in `for`, no `inline`), registers and `-O`, sizes (measured, `-Me -O`
  at $3000: empty 124 bytes, `write()` 308, `puts()` 1.8K, `printf()` 4.3K, of a double
  10K), speed, PEEK/POKE, `asm` (its CHROUT example ran in XRoar), interrupts (no
  keyword: assembly, FIRQ saves only PC and CC), the heap, data elsewhere, debugging.
  Re-check it when what it states changes. `FAQ.md`, at the top, is the chapter on its
  own (a heading, then the chapter as it is): `doc/mkfaq.sh` makes it (`make docs`),
  `faq.result` checks it is in step with the manual (`mkfaq.sh -c`). Change the manual,
  not FAQ.md. The spec has it in `%doc` (since 0.13.1).
- `doc/manual.md` is the user's manual (added 2026-11-09); `make docs` (`doc/mkmanual.sh`:
  pandoc, its man reader for the pages, which are its Appendix A, and xelatex, with
  `doc/tex/footnotehyper.sty` from plm09) makes `doc/manual.pdf`, which is committed.
  When a change alters what a program or target does, update the man page and the
  manual (and run `make docs`) in the same commit, as libc/README and this file.
- `doc/man/` has the man pages (added 2026-11-09): `bcc09.1`, `as09.1`, `ld09.1`, `ar09.1`,
  `objdump09.1` (`nm09.1` and `size09.1` are `.so` links to it) and `objcopy09.1`, written
  from the sources and checked against the tools; `make install` puts them in
  `$(MANDIR)` (`$(PREFIX)/share/man`). `tests/man.sh` (run by `make check`) checks that
  each formats without `groff -ww` warnings and names every option, from lists it keeps
  of each program's options: change a program's options, and change both. The passes
  have pages named `bcc09-cpp.1`, `bcc09-unproto.1` (dev86's, moved from `unproto/`, with
  a section on bcc09's `_PROTO_` and `_VA_ALIST_`), `bcc09-cc1.1` and `bcc09-copt.1`, so
  as not to clash with GCC's `cpp(1)` in a system's man directory. `bcc/bcc.doc`, which
  they replace, is gone.
- `stdint.h` has the 8-, 16- and 32-bit types (no 64-bit: `intmax_t` is `long`, `intptr_t`
  is `int`); `stdbool.h`'s `bool` is `cc1`'s `_Bool` (added 2026-11-08): an `unsigned char`
  type (`btype`) that every conversion makes 0 or 1 (`boolnode()` in `exptree.c` for
  assignments, casts, returns and initializers; `abop()` and `incdec()` for `op=`, `++`, `--`).
- Direct-page variables (2026-11-10/11, design approved: keyword `__direct`, OS-9
  included): cc1's `__direct` (`DIRECTDECL`, `gvardirect` beside `gvarsc` in
  `declare.c`, saved where it is) marks a global or static variable `DIRECTPAGE`
  (`DIRECTPAGE_BROKEN` is gone): segment 2, reached as `<name` (initialized in `LOC 2`,
  commons and local statics there too); errors for a function, typedef, parameter,
  auto or register variable, and for `__direct` in only some declarations. The
  `extern __direct` variables the code refers to are imported in `LOC 2`
  (`dpimport()`/`dumpdpimports()` in `table.c`; only those referred to, since an
  import links the definer), and ld09 makes an import in segment 2 that meets a
  definition or common block elsewhere an error, either order (`direct_import()`,
  `DIRECTIMPORT`/`HASSTORAGE` in `readobj.c`). The default layout already keeps
  segment 2 in one page (`ONEPAGE`); `rom.ld` and `vectrex.ld` have `*(LOC2) *(COMMON2)`
  in an `ONEPAGE` of their own. Probed in XRoar: Color, Extended, Disk (1.0, 1.1) and
  Super Extended BASIC's and the Dragon's interrupt handlers don't use DP, so a program
  may keep its own while it runs (DP 0 around ROM calls). Each start-up file (`sa`,
  `sim`, `rom`, `flex`, `vec`) sets DP to segment 2's page before the init functions,
  only if `__seg2DL` to `__seg2CH` isn't empty, so programs without `__direct` keep the
  DP they started with; `sa` (and `flex`) save the caller's in `__sysdp`, and `sa`'s
  `_exit` (libcb's too) gives it back. libc's calls keep the program's DP: `cb/rom.s`
  (POLCAT, CHROUT), `coco.s` (JOYIN) and `dskcon.s` call the ROM with DP 0 (`tone.s`
  already did); FLEX's (`flex.s`, and `_exit`'s FMSCLS/WARMS) with `__sysdp`; the
  Vectrex wrappers `jsr` the BIOS with $D0 ($C8 for music) and `puls dp,pc` (they
  `jmp`ed, leaving $D0: a program with `__direct` runs with $C8). cc1's `defstr()` kept a
  `__direct` char array's string in segment 3 (fixed: it stays in 2). `cbrom.s` and
  `cbdisk.s` print `#` if called with DP not 0. Tests: `direct.c` (cc1's output),
  `directerr.c`, `direct-ud`/`direct-du` (ld09), `dptest.c` (-Mi, and -O), `dpret.c`
  (-Ms under `dploader.s`, which calls with DP $5A and checks it comes back), `dpcb.c`
  (-Me with the stand-in ROM and disk), `flexdp.c`, `vecdp.c` (DP $C8, the BIOS $D0),
  `romdp.c` (`rom.ld`: a common block in its page); `xcoco.c` and `xdisk.c` use
  `__direct` variables on the real ROMs (`make check-xroar`). `-Mo`: with data through
  U, cc1 reaches a `__direct` variable's value as `<name` too (`dpdirect` in
  `outnnadr()`; its address stays `LEAX name,U`, and `[name,U]`, the 6809 having no
  direct indirect; plain `-p` keeps PC-relative data), since the default layout puts
  segment 2 first in the data area (offsets 0-255, data at 0 with `-i`) and DP is the
  data area's page (F$Fork's, and `crtos9` sets it from U); `-u`'s init functions store
  through `label,U`, so they don't need DP. `dptest` runs as an OS-9 module, under
  sim6809 and NitrOS-9 (`os9.result`, `check-nitros9`); `direct-u.s` is `direct.c`
  with `-Mo`. Documented (phase d): the manual's "Direct-page variables" (rules, each
  target's DP, a program's own ROM calls and C interrupt handlers), the calling
  conventions (DP is kept) and segments, `bcc09-cc1(1)`, `ld09(1)` (segment 2 and the
  error), `libc/README`'s DP paragraph, README, and the BASIC guide's "Faster
  variables" (its program is compiled by `basic.result`).
- cc1's `-c-` and `-f-` (callee saves, first argument on the stack) are errors (2026-11-10;
  they were accepted and ignored: `callersaves` and `arg1inreg` start TRUE and only `-c`
  and `-f` set them). Honored, `-f-` makes plausible code that libc (and `va_start`)
  can't call, and `-c-` pushes U and Y and never restores them; neither is worth a
  second libc. `ccsave.bcc` and `ccarg.bcc` test the messages.
- as09's `OS9 code` (added 2026-11-10; `mos9()`, routine `OS9CALL`, in page 1 as `SWI2`
  is) is an OS-9 system call: `SWI2` and the code, a byte, absolute; and a symbol may
  have `$` after its first character (`getsym()`), as OS-9's do (`I$WritLn`).
  `libc/os9/call.s`'s stubs use both (the same code; its equates are in the objects'
  symbols, as `RCC` and the others were). `os9op.s` and `os9err.s` test them.
- `bcc09` defines `__BCC__` (as dev86's headers expect), `__6809__`, `__STDC__` and a
  macro for the `-M` target (`__SIM6809__` for `-Mi`). `cc1` doesn't understand `const` or `volatile`;
  `libc/include/features.h` defines them away. `char` is unsigned.

## Tests

- `make check` (or `tests/run.sh`) runs the regression tests. They build the sources in
  `tests/src/` with this tree's tools and compare every result with the 874 reference
  files in `tests/ref/`. `tests/run.sh -u` refreshes the references; read the changed
  files before committing them.
- The references record current behavior, bugs included. `BUGS` lists the known bugs
  and the reference files that show each one; a fix changes those references.
- The tests run the tools through links in `tests/prefix.tmp/` and set `BCC_PREFIX`, so
  an installed copy (such as an old one in `/usr/local/bcc09`) is never used.
- `ld09` only loads modules that something refers to, even object files named on the
  command line. A symbol defined again is warned about only if both modules are linked
  (2026-11-09; it was at reading, so a program's own version of a library function
  warned): `redefinitions()` after `linksyms()`; `redef-quiet` and `redef-both` test it.
  A common block isn't followed to the module the symbol was given to (the first with
  the largest size) when the referring module has its own (`comflags` in `modstruct`,
  set by `readmodule()`; `linkrefs()`), and after linking, a common whose module isn't
  loaded goes to a loaded module that has it, with the largest size (2026-11-10): cc1
  makes `__opreg` a common in several modules, and FLEX's `file.o` loaded `scanfp.o`
  (and with it `__vscan`, `strtod`, `bignum` and the floating point helpers: 10K) for
  it; the math modules did the same to `mtest` (7K). A plain import that only a
  member's common satisfies still loads the member. `comm-quiet`, `comm-need` and
  `comm-ref` test it. ld01 (mc6801-tools) has the same `linkrefs()`, fixed the same way
  (mc6801-tools PR 70).
- Test programs run on `sim6809`, the sim6809 project's (`retrotinker/sim6809`, 1.2.0
  or later, which `run.sh` checks: 1.2.0's OS-9 directories, for `os9path.c`; `--os9`
  emulates OS-9's file, directory and `F$Mem` calls on the host, `--flex` puts
  `--param` in FLEX's line buffer and emulates FMS on host files, and the trace's
  `CYC=` counts cycles), from `PATH` or `$SIM6809` (the Makefile exports
  `SIM6809 ?= sim6809`, as plm09's does); `run.sh` stops if it isn't there. bcc09 kept
  a copy of plm09's 0.4.6 in `tests/sim` until 2026-11-10, when sim6809 became a
  project of its own; 1.1.0 gave every result the same. The spec `BuildRequires:
  sim6809 >= 1.2.0`, so a mock build needs its RPM in a repository (`createrepo_c` a
  directory with it, and `mock --addrepo`), as plm09's does.
- `tests/src/selftest.c` checks code from the other test
  sources against values from the host compiler and exits with the number of failures;
  it runs both as compiled and with `-O`; it also calls `float.c` (double arguments
  and results).
- `tests/src/ops.c` checks libc's 16-bit helpers and `memcpy` against `tests/src/opsdata.h`,
  which `tests/gen-opsdata.py` generates from a model of 16-bit C (rerun it after changing
  the operands or the model); `tests/src/longops.c` does the same for `long` with
  `tests/src/longdata.h` and `tests/gen-longdata.py`; `tests/src/fptest.c` checks the
  floating point helpers (arithmetic, comparisons, `++`/`--`, conversions) against
  `tests/src/fpdata.h` from `tests/gen-fpdata.py` (Python's doubles, and an exact model
  of rounding to float), whose tables must stay below `simcrt0.s`'s stack at `$7F00`.
  `tests/src/regtest.s` checks that the helpers keep the registers the compiler relies
  on (and, for floating point, pop and push what it expects). `crtret.c` and `crtexit.c`
  are built by `bcc09` alone (with `crt0` and `libc`) and run under `loader.s`, which
  calls `start` as a loader would and checks that the stack comes back; `crtatexit.c`
  checks that returning from `main` runs the `atexit()` functions, and
  `atexitio.c` that what one prints isn't lost (stdio's flush comes after them, through
  `__stdio_exit`; fixed 2026-11-09).
- `tests/src/strtest.c`, `stdtest.c`, `maltest.c` and `vatest.c` check libc's `string.h`,
  `ctype.h`, `stdlib.h`, `malloc` and `stdarg.h`; `run.sh` also builds them with the host's compiler and C library
  (`tests/host/putnum.c` supplies `putnum`), and each must print the same on both,
  which checks the expected results. Checks that depend on bcc09's type sizes or on
  functions only libc has are under `#ifdef __BCC__` or `sizeof` tests.
- `tests/src/pftest.c` (built with `-Mi`) prints a grid of `printf` formats, which must
  be byte-for-byte what the host's `printf` prints (as must `chartest.c`, chars passed
  and returned with prototypes, and `sadd.c`, ints and signed chars added and
  subtracted, `sftest.c`, a grid of `sscanf` formats and inputs and `scanf` reading
  `sftest.in`, `fltcc.c`, floats and doubles in many places in C, and `fpio.c`, `printf`'s
  floating formats, `strtod` and `scanf`'s `%f`, but for their counts of checks; and
  `mtest.c`, `math.h`'s functions, whose results must equal bit for bit those of
  `libc/math` built on the host; `inttest.c`, `stdint.h` and `_Bool`; `protoarg.c`,
  arguments converted to prototypes' types; `gltest.c`, `getline()` and `getdelim()`,
  POSIX's, added 2026-11-09 for `-Mo`'s and `-Me`'s CR-ended lines);
  `fpoptional.result` checks that `pftest` and `sftest` link none of that code; `siotest.c` checks the `FILE`
  functions and buffering against its expected output (`siotest.in` is its input).
- `make check-xroar` (`tests/xroar/run.sh`, optional: needs `xroar`, `python3` and the
  ROMs, in `~/.xroar/roms`) builds `tests/xroar/xcb.c` with `-Me`, puts it on a cassette
  with `objcopy09`, and runs it in XRoar on the CoCo, CoCo 2, Dragon 32 and Dragon 64:
  `CLOADM:EXEC` and the input are typed with `-type`, a trap at `__exit` takes a
  snapshot, and `xrscreen.py`/`xrcpu.py` read the text screen and the registers from
  it, which must match `tests/xroar/expected` and exit status 42 (CLOADM's `F` on the
  first line is inverse or not with the number of blocks: compared as `F`). With
  toolshed's `decb`, `xdisk.c` then runs with a disk (`decb dskini`, and `IN.DAT`) on the
  CoCo with Disk BASIC 1.0 and the CoCo 2 with 1.1 (`-cart rsdos -cart-rom diskNN`),
  where BASIC then reads its `OUT.TXT` and writes a file (a `PEEK(&HFF6A)` ends the
  run; screen in `expected-disk`), and on the CoCo 3 (exit status only: XRoar doesn't
  trap that `PEEK` there); `xrdisk.py` checks each disk: the files, and every used
  granule in one chain. Always run XRoar with `-ui null` and a timeout: `xroar -vo
  help`, for one, starts the emulator in a window. In scratch work, make a new
  `mktemp -d` directory rather than `rm` with a glob.
- `make check-flex` (`tests/flex/run.sh`, optional: needs `xroar`, `python3`, the Dragon 64
  and DragonDOS ROMs, and a Compusense FLEX disk, `$FLEX_DISK` or
  `~/coco/flex/FLEX_1.3.2.VDK`) puts `tests/flex/xflex.c` (`-Mf`) and `done.s` (at
  `$C600`, where XRoar traps) on a copy of the disk with `flexdisk.py` (plm09's), with
  its boot image patched not to ask the date (as plm09's dragonflex tests do); its
  `STARTUP` EXECs `P,XFLEX one,two three`, `P,FLEXFILE` (`tests/src/flexfile.c`) and
  `DONE`; the printer's output (XRoar's `-lp-file`) must equal `tests/flex/expected` and
  then flexfile's output under sim6809, and the files flexfile leaves, read off the disk
  (`flexdisk.py get`), must equal the ones it leaves under sim6809. FLEX has no exit
  status: the programs print their checks. The disk runs at real speed, so the run
  takes minutes of emulated time (`-timeout 900`; a DONE snapshot shows it finished).
  `FLEX_KEEP=1` keeps the files.
- `make check-nitros9` (`tests/nitros9/run.sh`, optional: needs `xroar`, toolshed's `os9`,
  a NitrOS-9 Level 2 boot disk, `$NITROS9_DISK` or `~/coco/nitros9.os9`, and the CoCo 3
  ROM, `$COCO3_ROM` or `/usr/share/mame/roms/coco3.rom`) boots NitrOS-9 on a CoCo 3 in
  XRoar with the `-Mo` modules (`os9io`, `os9dir`, `os9path` and the nine of `os9.result`) on a blank
  disk in
  drive 1 (40 tracks, double sided, as the boot's `D1` is: the boot disk is full); the
  startup script runs each through `trun.c` (`F$Fork` and `F$Wait`; added 2026-11-09),
  which writes its exit status to `NAME.rc`, with its output in a file, and `tdone.c`
  reads `$FF6A`, which XRoar traps on to stop. Each output and status must equal
  `tests/ref/NAME.run` and `NAME.run.rc`. `NITROS9_KEEP=1` keeps the disks, and
  `NITROS9_PROGS` picks the programs. About a minute and a half.
- Linker scripts: `tests/scripts/` has ld01's script tests, for the 6809 (sources and
  scripts, copied into `tests/out`): custom layouts, orphans, a ROM (MEMORY, AT>,
  NOLOAD, KEEP, FILL, BYTE/WORD, ASSERT, INCLUDE, srec and ihex output),
  EXCLUDE_FILE, NOLOAD errors, every script error, `example.ld` (ld09(1)'s example,
  which must stay the same as the page's), and `roundtrip.result`: links with `-P`'s
  script (also as bcc09 links `-Mi` and `-Mo`) give the same output and map as without.
  `splitprog.c` with `split.ld` (code at $0E00, data at $6000, no symbols defined)
  runs on sim6809, its init functions found through the provided `__seg5DL`.
- Twenty-one test programs are built again with `-O` and must run the same
  (`optimize.result`), which checks the copt rules.
- `pathlen.result`: as09 assembles a file of a 250-character name (it stopped at 64
  characters, and overflowed a buffer for a long module name: fixed 2026-11-09, found
  by the RPM's build in a long directory). fltcc.c and pftest.c compiled through
  prefixes of 20 to 240 characters
  must give the same code. cc1 writes a forward branch long and makes it short when its
  label comes within reach; `flushout()` keeps the text from the oldest such branch
  (`openpatch()`, growing the buffer), so that no longer depends on how much text,
  such as the headers' names in comments, comes between (fixed 2026-11-09).
- `tests/src/cocotest.c` checks `coco.h` (`cb/coco.s`, added 2026-11-10: `inkey`, `cls`,
  `locate`, `joystk`, `peek`/`poke`) with `cbrom.s` (which has a JOYIN at $A00A giving
  10, 20, 30, 40): the screen's bytes and CURPOS, and that `cls()` writes out stdout's
  buffer first (`__stdio_flushout`, set by stdio). `tests/xroar/xcoco.c` checks it on
  the real ROMs (`expected-coco`). stdio flushes a line-buffered stream at `'\r'` too.
  `sound(tone, duration)` (added 2026-11-10): `cb/tone.s` is BASIC's SOUND loop copied
  instruction for instruction from the ROM (CoCo $A964, Dragon $BAB3: $7E, $FE, $7E,
  $02 to the DAC, an INCA delay up from SNDTON $8C read with DP 0; a period is 100 + 20
  * (256 - tone) cycles: SOUND 89 260 Hz, middle C), with Y counting periods in the 8
  cycles BASIC's LDX/BNE take; `cb/sound.c` divides 59659 cycles (a fifteenth of a
  second, the CoCo's unit) by the period, so no interrupt is needed. `soundtest.c` is
  checked from sim6809's trace (`-t`): the writes to $FF20, counted and in turn, and
  each period's cycles (the trace's `CYC=`), which must be BASIC's but where a fifteenth
  of a second ends (`soundtest.dac`); `xcoco.c` plays middle C on the real ROMs (XRoar
  can't record audio).
- `tests/src/romtest.c` is a cartridge (`-Mr`, with `rom.ld` included by a script that
  sets `OUTPUT_FORMAT(srec)`) run on sim6809 from $C000 with `cbrom.s`: data copied, BSS
  cleared (sim6809 fills memory with $A5), init functions, input, heap, atexit; the run
  ends at the instruction limit in `_exit`'s loop. `make check-xroar` also runs
  `tests/xroar/xrom.c` as a cartridge (`-cart-rom`, `-cart-autorun`) on the CoCo, CoCo 2,
  Dragon 32 and Dragon 64, finding RAM in the snapshot by the data's first string at
  $0600 (`expected-rom`).
- `tests/src/vectest.c` is a Vectrex cartridge (`vectrex.ld` included with
  `OUTPUT_FORMAT(srec)`) run on sim6809 from crtvec's `start` with `vecbios.s`, which
  prints each BIOS call's registers and DP: it is linked at 0 with `org $F192` and so on
  (after an ORG, as09's labels are absolute but the bytes are placed from the segment's
  start), and only its S-records from $F000 are kept. `vectitle.s` is a header of a
  program's own. `make check-vectrex` (`tests/vectrex/run.sh`, optional: `mame` and the
  BIOS, `$VECTREX_ROM` or `~/vectrex/bnz17/SYSTEM.IMG`, CRC 34142feb, which isn't
  either of MAME's known dumps but runs, after a warning; or MAME's own set) runs
  `xvec.c` headless (`-video none`), `run.lua` stopping it at `_exit`'s loop (CURPC: a
  frame can end partway through an instruction) and printing the status and `results[]`
  from RAM (`expected`); MAME's own files go to the scratch directory
  (`-cfg_directory` and others), not the user's. Snapshots (`manager.machine.video:
  snapshot()` in Lua) work with `-video none`, for looking at the screen.
- `tests/src/cbfile.c` runs with `cbrom.s` and `cbdisk.s` (Disk BASIC's stand-in at
  `$C000`: DSKCON on tracks 16-18 kept in memory, granules 32-35 free) and checks
  `libc/cb/disk.c`: files of several granules, a full disk, deleting, truncating, and the
  FAT's and directory's bytes it prints.
- `tests/src/flexio.c` (`-Mf`, under `sim6809 --flex` with `--param` and input) checks
  argv and terminal I/O; `flexfile.c` FLEX's files, and leaves `TEXT.TXT`, `BIN.DAT`,
  `DRV.TXT` and `LOWER.TXT` in `tests/out` (sim6809's FMS writes host files there),
  which are references too, and what `make check-flex` compares FLEX's own with.
- `arops.result`: ar09's operations (adding at a position, appending, deleting, every
  kind of move, extracting), each under `timeout` and `ulimit -f`, since a broken move
  once looped writing its temporary file without end (fixed 2026-11-09).
- `tests/src/simcrt0.s` is start-up code for test programs that report through the
  simulator's I/O block; it isn't libc's `crt0`.

## Known issues

- The code is K&R C, so every Makefile builds with `-std=gnu89` (in `ALL_CFLAGS`, kept
  when `CFLAGS` is replaced). Without it, GCC 15 and
  later (C23 by default) can't build `bcc/`, `cpp/`, `ld/` or `unproto/`.
