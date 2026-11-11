bcc09: questions and answers
============================

The answers to the questions newcomers to bcc09 usually have.  This is
chapter 10 of the user's manual (doc/manual.pdf, from doc/manual.md,
where it is kept): the section and chapter numbers are the manual's.

## Running programs

**My Color BASIC program crashes the machine as soon as it starts.**
Give it a load address: `bcc09 -Me -o prog -X-T0x3000 prog.c`. Without
`-X-T`, a program is linked at address 0, on top of BASIC's own
variables. Color BASIC keeps its variables, the text screen and (Extended
and Disk BASIC) its graphics pages and disk buffers low in memory, and its
stack and strings at the top; `$3000` is above the low ones with BASIC's
usual settings, and leaves the heap the memory up to the stack.

**My lines run together, or print over each other.** Color BASIC, OS-9 and
FLEX end a line with a carriage return, `'\r'`, and the C library passes
characters as they are: print `"\r"` (on FLEX, `"\r\n"`) at the end of a
line (section 5.1).

**How do I try a program without a CoCo?** Build it for sim6809 (`-Mi`),
which runs on the computer you compile on and gives the program its
standard input and output:

```
bcc09 -Mi -o prog -X-T0x1000 prog.c
objcopy09 -O srec prog prog.srec
sim6809 prog.srec
```

For the machines themselves, emulators such as XRoar (CoCo and Dragon)
and MAME (Vectrex) run the cassettes, disks and cartridges bcc09 makes;
`make check-xroar` shows how.

**How do I make a cassette, a disk file, a cartridge, an OS-9 module or a
FLEX command?** `objcopy09` makes an executable into each (chapter 3, and
each target's section in chapter 5).

## The language

**Why does 40000 print as a negative number?** An `int` is 16 bits, from
-32768 to 32767, and C says a decimal constant over 32767 is a `long`.
Use `unsigned` (`40000U`, printed with `%u`) for 0 to 65535, or `long`
(printed with `%ld`) for more.

**Why is a `char` never negative?** `char` is unsigned, as the 6809's
loads of a byte are. Write `signed char` for -128 to 127.

**Is there a 64-bit integer?** No: `long`, 32 bits, is the largest
integer type (and `intmax_t` in `stdint.h`).

**Which C does it compile?** C89, with prototypes, `//` comments and C99's
`_Bool`. Declarations go at the start of a block, before its statements
(not in a `for`), and there is no `inline`. `const` and `volatile` aren't
known to the compiler: the library's headers define them away. `-kr`
compiles K&R C.

**A program that reads a hardware register gets the wrong value with `-O`.**
With no `volatile`, the optimizer takes a register written and then read
straight back to hold what was written. Compile the code that does that
without `-O` (`bcc09-copt(1)`).

## Size and speed

**Why is my program so big?** Mostly `printf()`: its formatting is about
4K, and floating point formats about 6K more, linked only when a program
prints a `float` or `double`. For a CoCo program that prints one line:

| Using | Program size |
|---|---|
| nothing (`return 0`) | 124 bytes |
| `write()` | 308 bytes |
| `puts()` | 1.8K |
| `printf()` | 4.3K |
| `printf()` of a `double` | 10K |

`-O` makes the code smaller too. `bcc09 -X-M` prints the link map, which
lists every module linked and its size; `size09` gives a program's code,
data and BSS.

**How fast is floating point?** About 2 ms for a `double` addition on a
CoCo, 5 ms for a multiplication and 9 ms for a division (chapter 4). Use
`int` and `long` where whole numbers will do.

**How do I make a program faster?** `-O`; `int` (or `unsigned char`)
rather than `long` or floating point; and `__direct` for the variables
used most (section 4.1).

## The machine

**How do I PEEK and POKE?** Through a pointer to the address: `POKE
1024,65` is `*(unsigned char *)1024 = 65;`, and `X=PEEK(&HFF00)` is
`x = *(unsigned char *)0xFF00;`. `coco.h` has `peek()` and `poke()` too.

**How do I call a ROM routine, or my own machine language?** Write a
function in assembly (section 7.2), or put instructions in a C function
with `asm`:

```c
void printa()
{
	asm("lda #'A", "jsr [$a002]");	/* CHROUT: print an A */
}
```

A program with `__direct` variables must give the ROM DP 0 around such a
call (section 4.1).

**Can I write an interrupt handler in C?** Not alone: there's no
`interrupt` keyword. A few lines of assembly can call a C function and
return with `RTI`; an IRQ has saved every register, but an FIRQ only PC
and CC, so its handler must push D, X, Y and U first. Such a C function
mustn't use `__direct` variables (section 4.1).

**How much memory does `malloc()` get?** The heap runs from the end of the
program up to 256 bytes below the stack pointer (on OS-9, it grows with
`F$Mem`); `malloc()` gives 0 when it's full. On OS-9, the stack is what
`objcopy09 -d` asks for, 1K by default.

**Can the data be somewhere other than straight after the code?** Yes:
`-X-D` gives the data's address, or a linker script puts it anywhere
(section 8.1). `objcopy09 -p` makes a cassette or a binary of such a
program (chapter 8).

## Finding bugs

**How do I find out what my program does?** Run it on sim6809 with `-t`,
which prints every instruction it runs, with the registers; `--cycles`
prints how many cycles it took. `bcc09 -S` shows the compiler's assembly,
`bcc09 -X-M` where everything is in memory, and `nm09` a program's
symbols. XRoar can stop at an address and save the machine's state
(`-trap`, `-trap-snap`), as `make check-xroar` does.

