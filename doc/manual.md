---
title: "bcc09"
subtitle: "A C compiler and tools for the Motorola 6809 -- user's manual"
author: "bcc09 project"
date: "November 2026"
toc: true
toc-depth: 2
numbersections: true
geometry: margin=2.5cm
fontsize: 10pt
colorlinks: true
---

# Introduction

bcc09 compiles C for the Motorola MC6809, the 8-bit processor of the Tandy
Color Computer, the Dragon 32 and 64, and many boards and systems of the
1980s and since. It comes with an assembler, a linker, a librarian, tools
to look into and convert the files they make, and a C library for the
systems a program can run on:

* **Color BASIC** (and Extended and Disk BASIC) on the CoCo 1, 2 and 3 and
  the Dragon: programs loaded with `LOADM` or `CLOADM` and run with `EXEC`,
  with the keyboard, the screen, and (on a CoCo) Disk BASIC's files.
* **OS-9** Level 1 and 2, and NitrOS-9: position-independent, reentrant
  program modules, with files, directories and a heap that grows.
* **FLEX**: commands (`.CMD` files), with the terminal and FLEX's files.
* **Standalone** code, loaded and called by a monitor or a loader.
* **sim6809**, the simulator bcc09's own tests run on.

bcc09 began as the 6809 configuration of Bruce Evans's C compiler from the
dev86 package, the tools Linux-8086 and ELKS were built with. dev86's 6809
compiler was never finished; bcc09 finishes it, fixes it, and adds the C
library, the targets, and a test suite that runs the programs it compiles,
on a simulator and on real ROMs and systems in the XRoar emulator.

This manual describes how to use it: building and installing it (chapter
2), compiling a first program for each target (3), the C it compiles (4),
each target (5), the C library (6), how compiled code calls functions, so
that assembly can be written to work with it (7), and the tools (8).
Appendix A is the reference: the manual pages of every program.

bcc09 is free software. The compiler and tools are under the GNU General
Public License; the C library, which is linked into the programs bcc09
builds, is under the GNU Library General Public License, version 2, so
that those programs can be under any license.

# Building and installing

bcc09 builds on any Unix-like system with a C compiler and `make`:

```
make
make check
make install PREFIX=/usr/local/bcc09
```

`make` builds the programs and the C library (which bcc09 compiles itself).
`make check` runs the regression tests (chapter 9). `make install` puts:

* the programs `bcc09`, `as09`, `ld09`, `ar09`, `objdump09` (also
  installed as `nm09` and `size09`) and `objcopy09` in *PREFIX*`/bin`;
* the compiler's passes (`cpp`, `unproto`, `cc1`, `copt` and its rules) in
  *PREFIX*`/libexec/bcc09`;
* the C library, the targets' start-up code and libraries in
  *PREFIX*`/share/bcc09`, and its headers in *PREFIX*`/share/bcc09/include`;
* the manual pages in *PREFIX*`/share/man/man1`.

*PREFIX* is `/usr/local/bcc09` by default. bcc09 finds its passes and
library under the *PREFIX* it was built with, or under the directory the
environment variable `BCC_PREFIX` names: so a build tree can be used without
installing it, by pointing `BCC_PREFIX` at a directory of links to it, as
the tests do.

`make install` also takes `DESTDIR`, a directory to install into as if it
were the root, for making packages: bcc09 still looks for its files under
*PREFIX*. The host compiler's options can be set with `CFLAGS` and
`LDFLAGS` (in the environment or on `make`'s command line); `-std=gnu89`
and what each program needs are always added.

On Fedora, `make rpm` builds an RPM package from `bcc09.spec`, with
*PREFIX* `/usr`, in `rpmbuild/`: from the release's tag (`v0.9.0`), or from
the last commit if that isn't tagged yet. `make srpm` builds the source
package alone.

# Getting started

A first program:

```c
#include <stdio.h>

int main()
{
	printf("HELLO, WORLD\r");
	return 0;
}
```

The `\r` is not a mistake: Color BASIC, OS-9 and FLEX end a line with a
carriage return, and bcc09's C library passes characters to them as they
are (section 5.1).

## For Color BASIC

```
bcc09 -Me -O -o hello -X-T0x3000 hello.c
objcopy09 -O cas -n HELLO hello hello.cas
```

`-Me` chooses the Color BASIC target, `-O` the optimizer, and `-X-T0x3000`
gives the linker the load address, low in memory, below BASIC's stack and
strings. `hello` is an executable (an a.out file); `objcopy09` makes it a
cassette image. In an emulator, or played to a real CoCo or Dragon:

```
CLOADM:EXEC
```

For a disk, `objcopy09 -O decb hello HELLO.BIN` makes a file for `LOADM`.

## For OS-9

```
bcc09 -Mo -O -o hello.out hello.c
objcopy09 -O os9 -n hello hello.out hello
```

`hello` is a program module: copy it to a disk's `CMDS` directory (with the
execute attributes set), and run it from the shell.

## For FLEX

FLEX's terminal wants a line feed after the carriage return, so the
program prints `"HELLO, WORLD\r\n"`. Then:

```
bcc09 -Mf -O -o hello -X-T0x1000 hello.c
objcopy09 -O flex hello HELLO.CMD
```

Put `HELLO.CMD` on a FLEX disk, and type `HELLO`.

## For a monitor, or a machine of one's own

```
bcc09 -O -o prog -X-T0x4000 prog.c
objcopy09 -O srec prog prog.s19
```

The default target, `-Ms`, has no I/O: `main` is called, and its result is
returned in D to whatever called the program. Section 5.2 tells how to give
such a program I/O.

# The C language

bcc09 compiles C89, with these sizes:

| Type | Size | Notes |
|---|---|---|
| `char` | 8 bits | unsigned |
| `short`, `int` | 16 bits | |
| `long` | 32 bits | |
| pointers | 16 bits | |
| `float` | 32 bits | IEEE 754 single precision, big-endian |
| `double` | 64 bits | IEEE 754 double precision, big-endian |
| `_Bool` | 8 bits | C99's: any value converted to it is 0 or 1 |

Numbers are big-endian, like the 6809's: the most significant byte first.
There is no 64-bit integer type.

* **Prototypes** work as C89 says: a call converts each argument to its
  parameter's type, through a pointer to a function too, and a call with
  the wrong number of arguments is an error. (A pass called `unproto`
  rewrites ANSI C to the older form the compiler reads, and tells it the
  parameters' types; `-kr` leaves it out, for K&R C.)
* **`const` and `volatile`** aren't known to the compiler: the C library's
  headers define them away, so a program that uses them must include one.
* **Floating point** is in software, exact: every operation gives the
  correctly rounded result IEEE 754 calls for, the same as a host's
  hardware, with infinities, NaNs and denormals. `float` arithmetic is done
  in `double`, and rounded when it is stored.
* **Constants:** with a 16-bit `int`, a decimal constant over 32767 is a
  `long`, as C says; write `40000U` for an `unsigned int`.
* **What C leaves undefined** is as follows: signed division truncates
  toward zero; dividing by zero doesn't trap; shifting by the operand's
  width or more gives 0 (or copies of the sign bit for a signed right
  shift); a floating value converted to an integer type it doesn't fit
  gives its low bits.

The preprocessor defines `__BCC__`, `__6809__`, `__STDC__` (unless `-kr`),
and a macro for the target: `__CB__`, `__OS9__`, `__FLEX__` and
`__FLEX9__`, `__STANDALONE_`, or `__SIM6809__`.

# Targets

bcc09's `-M` option chooses what a program is for. Each target has its own
start-up code and a library of the functions that differ (input, output,
files, the end of the program), which `bcc09` links with the C library:

| Option | Target | Start-up, library | Output |
|---|---|---|---|
| `-Ms` | standalone (default) | `crt0.o`, `libsa.a` | any (`objcopy09`) |
| `-Me` | Color BASIC, run with `EXEC` | `crt0.o`, `libcb.a` | `cas`, `wav`, `decb` |
| `-Mr` | ROM cartridge (CoCo, Dragon) | `crtrom.o`, `librom.a`, `rom.ld` | the ROM's image |
| `-Mv` | Vectrex cartridge | `crtvec.o`, `libvec.a`, `vectrex.ld` | the ROM's image |
| `-Mo` | OS-9 program module | `crtos9.o`, `libos9.a` | `os9` |
| `-Mf` | FLEX command | `crtflex.o`, `libflex.a` | `flex` |
| `-Mi` | sim6809 | `crtsim.o`, `libsim.a` | `srec` |

(`-Mu` and `-Mb`, for Color BASIC `USR` functions and Disk BASIC, define
their macros but have no start-up code yet.)

Every target's start-up code clears the BSS, calls the *init functions*
(section 7.4), then `main`; `main`'s result goes to `exit()`, which calls
the functions `atexit()` registered, last first, and then the target's
`_exit()`. The heap, which `malloc` uses, lies between the end of the
program and its stack.

## Lines

Color BASIC, OS-9 and FLEX end a line of text with a carriage return (CR,
`'\r'`), not C's `'\n'`; FLEX's terminal also wants a line feed after it to
start a new line. bcc09's C library doesn't translate: `read()` and
`write()` pass characters as they are. So a program for those systems
prints `"\r"` (on FLEX, `"\r\n"`) to end a line, and reads lines ending in
`'\r'`. `fgets()` stops only at `'\n'`; POSIX's `getdelim()` reads up to any
character:

```c
char *line = 0;
size_t size = 0;

while (getdelim(&line, &size, '\r', stdin) > 0)
	/* line is the line, with its '\r' */ ;
```

## Standalone (`-Ms`)

The program runs on the stack its loader gave it, and returns to it:
`main`'s result (or `exit()`'s argument) is in D. It has no I/O: `read()`
and `write()` aren't there. To give it I/O, write them (section 7), and
link with `-x`, which leaves out the start-up code, and a start-up file of
one's own.

## Color BASIC (`-Me`)

The program runs on BASIC's stack and returns to BASIC. Load it low (`-X-T0x3000`, say), below BASIC's stack and string space at the top of
memory; the heap is the memory between the end of the program and the
stack.

* **Output:** `write()` (and so `printf()`) prints on the screen through
  the ROM's `CHROUT`.
* **Input:** `read()` reads a line from the keyboard through `POLCAT` as a
  terminal does: the keys are shown as they are typed, the left arrow rubs
  out, and ENTER ends the line (with a CR). BREAK at the start of a line is
  the end of the input.
* **Files,** with Disk BASIC on a CoCo: `open()` and `unlink()`, and
  `read()`, `write()`, `lseek()` and `close()` on what `open()` gives, so
  `fopen()` too. Names are `NAME.EXT` (or `NAME/EXT`), with `:D` for drive
  *D*. bcc09 reads and writes the disk's sectors through Disk BASIC's
  `DSKCON`, keeping the FAT and directory as Disk BASIC does: a new file is
  a data file, ASCII, its granules chosen as Disk BASIC chooses them, so
  BASIC and a program can share a disk. On a full disk, `write()` writes
  what fits and then fails with `ENOSPC`. `lseek()` can't go past a file's
  end. A program that opens no files doesn't carry this code.

The Dragon's ROM has the same `POLCAT` and `CHROUT`, so programs run on
the Dragon 32 and 64 too, but without files: DragonDOS's disks are of
another format, and `open()` fails with `ENODEV` there.

## ROM cartridges (`-Mr`)

A program in a cartridge's ROM, which the CoCo and the Dragon start by
themselves (with the cartridge's CART line wired to Q, as in a game
cartridge): BASIC's FIRQ handler jumps to `$C000`. `bcc09 -Mr` links it
with the linker script `rom.ld` (section 8.1), and its output is the ROM's
image, ready for an EPROM or for XRoar:

```
bcc09 -Mr -O -o hello.rom hello.c
xroar -cart-rom hello.rom -cart-autorun
```

* **The ROM,** from `$C000`: the code, then an image of the initialized
  data, filled out with `$FF` to 8K, or to 16K less the last page (`$FF00`
  up is I/O).
* **The RAM:** the data, the BSS and the heap from `$0600`, after the text
  screen; the stack below `$8000`, a 32K machine's top (`-X-A__stack_top=0x4000`
  for 16K).
* **Start-up:** with the interrupts off (and the cartridge's FIRQ turned
  off), the start-up code sets the stack, copies the initialized data to
  RAM, clears the BSS, and calls the init functions and `main`.
* **I/O,** as with `-Me` (but no files): the screen and keyboard through
  the ROM's `CHROUT` and `POLCAT`.
* **The end:** a cartridge has nothing to return to, so `_exit()` stops,
  with the status in D.

The CoCo 3 starts a cartridge before its BASIC is ready for `CHROUT` and
`POLCAT`, so `-Mr`'s I/O doesn't work there. For another layout, copy
`rom.ld` (from bcc09's library directory), change it, and link with
`-X-S` and the copy.

## Vectrex (`-Mv`)

A Vectrex cartridge. The BIOS checks the cartridge's header, shows its
title, plays its tune, and then runs the code after the header:

```c
#include <vectrex.h>

int main()
{
	for (;;) {
		Wait_Recal();
		Intensity_a(0x7F);
		Print_Str_d(0, -40, "HELLO\200");
		Reset0Ref();
		Moveto_d(-30, -30);
		Draw_Line_d(0, 60);
	}
}
```

```
bcc09 -Mv -O -o hello.bin hello.c
mame vectrex -cart hello.bin
```

* **The ROM,** from `$0000`: the header, the code, and an image of the
  initialized data (up to 32K).
* **The RAM** is the Vectrex's 1K, less the BIOS's own variables: the
  data and BSS from `$C880`, the stack below `$CBEA`. That is room for a
  game's variables, but not for stdio's buffers, and the heap is small.
* **Start-up:** the start-up code sets the stack and DP (`$D0`, where the
  BIOS's routines want it), copies the initialized data to RAM, clears
  the BSS, and calls the init functions and `main`.
* **The BIOS:** `vectrex.h` declares its routines for drawing
  (`Wait_Recal`, `Intensity_a`, `Moveto_d`, `Draw_Line_d`, `Dot_d`,
  `Draw_VLc`, `Print_Str_d`, `Reset0Ref`), the controllers (`Read_Btns`,
  `Joy_Digital`), sound (`Init_Music_chk`, `Do_Sound`) and `Random`, with
  the names Vectrex programmers know, and its variables (`Vec_Btn_State`,
  `Vec_Joy_1_X`, `VIA_t1_cnt_lo` for the scale, and others). Coordinates
  are -128 to 127, y first; the BIOS's strings are in capitals and end
  with `\200` (`$80`), not 0.
* **No other I/O:** `read()` and `write()` aren't there, so neither is
  stdio.
* **The end:** `_exit()` stops, with the status in D.

The header is `libvec.a`'s, with the title "BCC09", unless the program
has its own: `vectrex.h` shows one, an assembly file of a few lines,
linked with the program (`bcc09 -Mv -o game.bin game.c title.s`). For
another layout, copy `vectrex.ld`, change it, and link with `-X-S` and
the copy.

## OS-9 (`-Mo`)

The program is an OS-9 program module: its code is position-independent
(`LBSR` for calls, `,PCR` for constants), and its data is reached through
the U register, which points at the data area F$Fork gives each process,
so the module is reentrant: one copy in memory serves every process
running it. `bcc09 -Mo` builds the whole C library this way.

```
bcc09 -Mo -O -o prog.out prog.c
objcopy09 -O os9 -n prog -d 2048 prog.out prog
```

`-d` sets the stack's size (1K by default). The start-up code copies the
data's initial values from the module to the data area, clears the BSS,
and runs the code that sets static variables holding addresses (which
aren't known until the program runs). `main` gets the command line's words
(`argv[0]` is the module's name; `"..."` keeps words together).

* **I/O:** `read()` and `write()` use `I$ReadLn` and `I$WritLn`, which a
  terminal edits and echoes a line at a time; `read()` gives at most a
  line, up to its CR.
* **Files:** `open()` (with `O_CREAT`, `O_EXCL`, `O_TRUNC` and
  `O_APPEND`), `lseek()`, `unlink()`, `remove()`.
* **Directories:** `mkdir()`, `chdir()`, and `opendir()`, `readdir()`,
  `rewinddir()` and `closedir()` (`dirent.h`).
* **The heap** grows with `F$Mem` beyond the data area F$Fork gave
  (Level 1 can only grow it if the memory after it is free).
* **errno:** OS-9's errors become `ENOENT`, `EBADF`, `EACCES`, `EEXIST`,
  `ENOMEM`, or `EIO`.

## FLEX (`-Mf`)

The program is a FLEX command. Its start-up code moves the stack from
FLEX's own small one to the end of user memory, and gives `main` the
command line's words: `argv[0]` is the command's name as typed (`"P,PROG"`,
which prints PROG's output, gives `PROG`), and the rest are the words after
it, separated by blanks or commas.

* **Output** goes through FLEX's `PUTCHR`, so FLEX's `P` and `O` commands
  redirect it; **input** comes a line at a time from `INCH`, echoed, with
  TTYSET's backspace character to rub out.
* **Files**, through FLEX's File Management System: `open()`, `unlink()`
  and `rename()`. FLEX writes only new files from their start: writing to
  an existing file needs `O_TRUNC` (which `fopen(name, "w")` gives), which
  replaces it; `O_RDWR` and `O_APPEND` aren't possible. Files are text,
  with FLEX's space compression, unless opened in binary (`O_BINARY`, or
  `"b"` in `fopen()`'s mode); a binary file reads back with the zeros that
  pad its last sector, since FLEX keeps a file's size only in sectors.
  `lseek()` works on a file open for reading.
* **The end:** `_exit()` closes every file and returns to FLEX (FLEX has no
  exit status).

## sim6809 (`-Mi`)

For the simulator bcc09's tests use (`tests/sim`, from the plm09 project):
standard output goes to the simulator's output, standard input comes from
its input, and `main`'s result becomes the simulator's exit status. There
are no files.

# The C library

The headers are `ctype.h`, `dirent.h`, `errno.h`, `fcntl.h`, `limits.h`,
`malloc.h`, `math.h`, `stdarg.h`, `stdbool.h`, `stddef.h`, `stdint.h`,
`stdio.h`, `stdlib.h`, `string.h`, `unistd.h`, `sys/stat.h` and
`sys/types.h`. Most of the library is dev86's, fixed; the parts that
needed it were written for bcc09. Each function is a module of its own,
so a program carries only what it uses.

* **stdio:** the `FILE` functions; the `printf` and `scanf` families,
  which behave as the GNU C library's do; and POSIX's `getline()` and
  `getdelim()`.
* **Floating point in text:** `printf`'s `%e`, `%f` and `%g` print the
  exact decimal value of a double, and `strtod()`, `atof()` and `scanf`
  give the double nearest the number they read, as the GNU C library's
  do. This code is linked only into programs that print or read a floating
  point number. (`%a` isn't done in `printf` yet.)
* **math.h:** the C89 functions, from Sun's fdlibm, whose results are bit
  for bit what the same code gives on any IEEE host; `errno` is set as the
  GNU C library sets it.
* **stdint.h** has the 8-, 16- and 32-bit types; **stdbool.h**'s `bool`
  is the compiler's `_Bool`.
* **malloc** gets memory from `sbrk()`. Except on OS-9, the heap may not
  come within `__heap_margin` bytes (256) of the stack pointer: a program
  that needs a deeper stack after filling its heap should raise it.

What is still to come: `div()` and `ldiv()`, `%a` in `printf`, and the
functions of later C standards beyond those named here.

# Calling conventions and assembly

## Functions

A C function's first argument is passed in X (a `long`'s in D and X,
high word in D); the others are on the stack, above the return address,
in order, and the caller removes them. A `float` argument is passed as a
`double`, and a `double` is always on the stack, even as the first
argument. The result:

| Type | Result in |
|---|---|
| `char`, `int`, pointer | X |
| `long`, `float` | D and X (high word in D) |
| `double` | D, X, Y and U (high word in D; in memory, as `PSHS D,X,U,Y` leaves them) |

The caller saves the registers it needs: a function may change them all
(but U under `-Mo`, where it points at the data). A function name in C is
the assembler's name with an underscore before it: `main` is `_main`.

A function with a variable argument list gets, in place of `...`, an `int`
parameter named `__va_alist`, which `stdarg.h`'s `va_start` uses: the first
argument comes in a register, so the address of the last named parameter
doesn't lead to the rest.

## An assembly function

```
; int twice(int n): n * 2
        .text
        export  _twice
_twice: tfr     x,d             ; n, the first argument
        lslb
        rola
        tfr     d,x             ; the result, in X
        rts
```

Assembled with `as09 -o twice.o twice.s`, it links with C code that
declares `int twice(int n);`.

## Run-time helpers

The compiler calls helpers in the C library for what the 6809 can't do in
a few instructions: 16-bit multiplication, division and shifts (`imul`,
`idiv`, `isl` and the rest: operands in D and X, result in D), 32-bit
arithmetic (`ladd_b`, `lmul_b` and the rest: the left operand in D:X, Y
pointing at the right, the result in D:X), and floating point (`Fadd`,
`Fmul`, conversions and the rest). The int and floating point helpers
keep Y and U, the long ones U. The C library's README lists them all.

## Init functions and segments

The assembler's 16 segments (`LOC` 0 to 15) are placed by the linker: 0
and 1 are code, 3 the data and then the BSS (`.data` and `.bss`). A module
can have a function run before `main` by putting its address in segment 5:

```
	loc	5
	fdb	myinit
```

The start-up code calls each one (skipping the zeros the linker pads the
segment with). That is how the floating point formatting is linked into
programs that need it, and how OS-9 programs set static variables that hold
addresses.

# The tools

* **`as09`**, the assembler: Motorola syntax (`LDA #$10`, `LEAX 4,S`,
  `FCB`, `FDB`, `FCC`, `RMB`, `EQU`), `export` and `import` for symbols
  shared between modules, `.text`, `.data` and `.bss`, conditionals and
  macros. Numbers are `$` or `0x` hex, `%` binary, decimal, or octal with a
  leading 0.
* **`ld09`**, the linker: links object files and libraries into an
  executable (an a.out file), loading only the modules something refers
  to. `-T` gives the code's address (hexadecimal), `-i` puts the data at 0
  (OS-9's way), `-m` and `-M` list the modules and the layout, and `-S`
  takes a linker script (section 8.1).
* **`ar09`** makes libraries: `ar09 rc libmine.a one.o two.o`.
* **`objdump09`**, `nm09` and `size09` show what is in object files,
  libraries and executables.
* **`objcopy09`** writes an executable as what a machine loads:

| Format | For |
|---|---|
| `binary` | the bytes alone |
| `srec`, `ihex` | Motorola S-records, Intel hex: EPROM programmers, monitors |
| `decb` | Disk Extended Color BASIC's `LOADM` |
| `cas`, `wav` | Color BASIC's `CLOADM`, as a cassette image or its sound |
| `ddos` | DragonDOS |
| `os9` | an OS-9 program module |
| `flex` | a FLEX command (`.CMD`) |

Appendix A has each program's options in full.

## Linker scripts

A linker script says where the linker puts each part of a program. Without
one, `ld09` uses its default script, which `ld09 -P` prints (with the `-T`,
`-D` and `-H` given): the code at the text address, the data straight
after it, and the BSS after the data. A script of one's own can put the
code and data anywhere, in any order, store data in ROM to be copied to
RAM, fill gaps, define symbols, and write S-records or Intel hex itself.
`ld09(1)` describes the language; it comes from `ld01`, the linker of the
mc6801-tools project, where it is GNU ld's in a smaller form.

This one puts a Color BASIC program's code low in memory, at `$0E00`, and
its data and BSS at `$6000`, out of the way:

```
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
```

```
bcc09 -Me -O -o prog -X-Ssplit.ld prog.c
objcopy09 -O decb prog PROG.BIN
```

`LOCn` is segment *n* of every module, and `COMMON` the common blocks
(uninitialized variables). The script needn't define anything for the C
library: `ld09` provides the symbols the start-up code uses (`__edata` and
`__end`, between which it clears the BSS, and `__seg5DL` and `__seg5DH`
around the init functions). The init functions must be in one place, so
segment 5 has a statement of its own: a statement takes its input module by
module. `objcopy09 -O decb` writes the code and the data as two blocks,
which `LOADM` puts in their places.

# Testing

`make check` runs bcc09's regression tests: it compiles the test sources
with this build's tools, runs the programs on sim6809 (for every target:
Color BASIC with stand-ins for its ROMs, OS-9 modules and FLEX commands
with the simulator's emulation of their systems, cartridges with
stand-ins for BASIC's ROM and the Vectrex's BIOS), compares every result
with a reference copy, and checks the manual pages. Many of the
programs are also compiled with the host's C compiler, and must print
the same.

Four more test suites run programs on real ROMs and systems, in the XRoar
and MAME emulators, if they and the ROMs and disks they need are there:

* `make check-xroar`: Color BASIC on the CoCo 1, 2 and 3 and the Dragon 32
  and 64, with Disk BASIC's files on the CoCos, and ROM cartridges;
* `make check-nitros9`: OS-9 modules on NitrOS-9 Level 2;
* `make check-flex`: FLEX commands, and FLEX's files, on Compusense FLEX
  for the Dragon 64;
* `make check-vectrex`: a Vectrex cartridge on the Vectrex's BIOS in MAME
  (`$VECTREX_ROM`, or MAME's own ROM set).

# Appendix A: the manual pages {.unnumbered}

The pages that `man` shows for each program follow.
