#!/bin/sh
#
# Regression tests for bcc09.
#
# Preprocesses, compiles, assembles, archives, links and converts the
# sources in src/, and compares every result (assembly, object files,
# executables, listings, link maps, dumps, converted images, messages
# and exit statuses) with the reference copies in ref/.  The references
# record what the tools do today, bugs included: ../BUGS lists the known
# bugs and the reference files that show each one.
#
# usage: run.sh [-u]
#   -u  update the reference copies from this build instead of comparing

top=$(cd "$(dirname "$0")/.." && pwd)
tests=$top/tests
out=$tests/out
ref=$tests/ref

update=0
if [ "${1:-}" = "-u" ]; then
	update=1
fi

# sim6809 runs the test programs (make check builds it)
SIM=$tests/sim/sim6809
if [ ! -x "$SIM" ]; then
	echo "run.sh: $SIM is missing (make check builds it)" >&2
	exit 2
fi

export LC_ALL=C

rm -rf "$out"
mkdir -p "$out"
cd "$out" || exit 1

# a prefix of links to this build: the compiler driver finds its passes
# under BCC_PREFIX, so an installed copy is never used; and the tools
# are run by name from its bin, so that messages that include the
# program's name don't depend on where the source tree is
prefix=$tests/prefix.tmp
rm -rf "$prefix"
mkdir -p "$prefix/bin" "$prefix/libexec/bcc09"
ln -s "$top/as/as09" "$top/ld/ld09" "$top/ar/ar09" "$top/bcc/bcc09" \
	"$top/ld/objdump09" "$top/ld/objcopy09" "$prefix/bin/"
ln -s "$top/cpp/cpp" "$top/bcc/cc1" "$top/copt/copt" "$top/copt/rules.6809" \
	"$top/unproto/unproto" "$prefix/libexec/bcc09/"
mkdir -p "$prefix/lib/bcc09"
ln -s "$top/libc/libc.a" "$top/libc/include" "$top/libc/crt0.o" \
	"$top/libc/libsa.a" "$top/libc/libcb.a" "$top/libc/crtsim.o" \
	"$top/libc/libsim.a" "$top/libc/crtos9.o" "$top/libc/libos9.a" \
	"$top/libc/crtflex.o" "$top/libc/libflex.a" \
	"$prefix/lib/bcc09/"
LIBDIR=$prefix/lib/bcc09
# (relative to $out, where everything runs: the compiler's output names
# the headers it read, so an absolute path would make the results
# depend on where the source tree is)
export BCC_PREFIX=../prefix.tmp
unset BCC_EXEC_PREFIX
PATH=$prefix/bin:$PATH

AS=as09
LD=ld09
AR=ar09
BCC=bcc09
CPP=$prefix/libexec/bcc09/cpp
OD=objdump09
OC=objcopy09

# the sources are copied here so that file names in the results have no
# directory
cp "$tests"/src/* .

# run NAME COMMAND...: messages and exit status
run() {
	name=$1
	shift
	"$@" > "$name.err" 2>&1
	echo $? > "$name.rc"
}

# link NAME OPTION...: executable, -m/-M map, messages and exit status
# (the map's last line, the linker's own memory use, isn't compared)
link() {
	name=$1
	shift
	"$LD" "$@" -o "$name.out" > "$name.map.tmp" 2> "$name.err"
	echo $? > "$name.rc"
	sed '/^Total memory used: /d' "$name.map.tmp" > "$name.map"
	rm -f "$name.map.tmp"
}

# the preprocessor, on its own: macros, conditionals, includes, and
# ANSI mode (-A, as bcc09 runs it); with a command-line definition;
# and its error messages
"$CPP" cpp.c > cpp.i 2> cpp.err
echo $? > cpp.rc
"$CPP" -A cpp.c > cpp-A.i 2> cpp-A.err
echo $? > cpp-A.rc
"$CPP" -A -DCMDLINE=9 cpp.c > cpp-D.i 2> cpp-D.err
echo $? > cpp-D.rc
"$CPP" cpperr.c > cpperr.i 2> cpperr.err
echo $? > cpperr.rc
# and through the driver
"$BCC" -E cpp.c > cpp-E.i 2> cpp-E.err
echo $? > cpp-E.rc

# the compiler: assembly from each C source, without and with the
# peephole optimizer (-O); then object files
csrc="arith calls cbtest chartest control float helpmain long longops main
      maltest ops pftest proto ptr sadd selftest sftest siotest stdtest strtest
      struct switch vatest"
for f in $csrc; do
	run $f.cc "$BCC" -S -o $f.s $f.c
	run $f-O.cc "$BCC" -O -S -o $f-O.s $f.c
	run $f.c.cc "$BCC" -c -o $f.o $f.c
done
# compiler errors
run syntax.cc "$BCC" -S -o syntax.s syntax.c
rm -f syntax.s

# the assembler: object file, listing and symbol file
for f in crt0 modes regtest simcrt0; do
	run $f.as "$AS" -o $f.o -l $f.lst -s $f.sym $f.s
done
# the compiler's output, assembled with a listing (-u, as bcc09 runs as09)
run main.as "$AS" -u -o main-as.o -l main.lst main.s
if cmp -s main.o main-as.o; then
	echo "ok   bcc09 -c gives the same object as bcc09 -S and as09"
else
	echo "DIFF bcc09 -c and bcc09 -S + as09 give different objects"
fi > main-as.result
rm -f main-as.o

# the librarian: the member list only, since the member headers hold
# file dates; and objdump09 on the archive, which shows each member
run libtest.ar "$AR" rc libtest.a control.o ptr.o
"$AR" t libtest.a > libtest.t
"$OD" libtest.a > libtest.a.dump 2>&1

# the linker: the test program, from objects and from the library, with
# maps; stripped; headerless; with separate data; at address 0 (for
# OS-9)
link prog	-m -M -T0x1000 crt0.o main.o control.o ptr.o
link prog-lib	-m -M -T0x1000 -L. crt0.o main.o -ltest
link prog-s	-s -T0x1000 crt0.o main.o control.o ptr.o
link prog-d	-d -T0x1000 crt0.o main.o control.o ptr.o
link prog-D	-m -M -T0x1000 -D0x4000 crt0.o main.o control.o ptr.o
link prog-0	-T0 crt0.o main.o control.o ptr.o
if cmp -s prog.out prog-lib.out; then
	echo "ok   prog-lib.out is the same as prog.out"
else
	echo "DIFF prog-lib.out and prog.out"
fi > prog-lib.result
rm -f libtest.a
# linker errors: code that needs the run-time helpers that aren't
# written yet (the list of what's missing), and a module without main;
# ld09 only loads the modules that something refers to, so helpmain.c
# calls into the others
link helpers	-T0x1000 crt0.o helpmain.o arith.o long.o float.o struct.o \
		calls.o
link nomain	-T0x1000 control.o
# and with libc, which has them all
link helpers-lc	-T0x1000 crt0.o helpmain.o arith.o long.o float.o struct.o \
		calls.o -L"$LIBDIR" -lc

# objdump09 (and nm09 and size09, which are the same program) on
# object files and executables
for f in crt0 modes main long; do
	"$OD" $f.o > $f.o.dump 2>&1
done
for f in prog prog-s prog-D; do
	"$OD" $f.out > $f.dump 2>&1
done
"$OD" -n prog.out > prog.nm 2>&1
"$OD" -n main.o > main.o.nm 2>&1

# objcopy09: each output format, and separate data (-D), with the load
# addresses given
for f in binary srec ihex decb ddos cas wav flex; do
	run prog-$f.oc "$OC" -O $f -n PROG -T 0x1000 prog.out prog.$f
done
run prog-p.oc "$OC" -O binary -p -T 0x1000 -D 0x4000 prog-D.out \
	prog-p.binary
run prog-D.oc "$OC" -O decb -T 0x1000 -D 0x4000 prog-D.out prog-D.decb
run prog-Dsrec.oc "$OC" -O srec -n PROG -T 0x1000 -D 0x4000 prog-D.out \
	prog-D.srec
# without them, objcopy09 finds them from __btext and __bdata, which
# ld09 always writes: this must be the same as prog.srec
run prog-noT.oc "$OC" -O srec -n PROG prog.out prog-noT.srec
run prog-os9.oc "$OC" -O os9 -n Prog -d 0x200 -v 1 prog-0.out prog.os9
run prog-os9r.oc "$OC" -O os9 -n Prog -d 0x200 -r prog-0.out prog-r.os9
# objcopy09: an OS-9 module without -d (1K of stack and heap; and
# prog-0.out's data isn't at 0, a warning); errors: a bad format name;
# an address that doesn't fit in 16 bits
run os9-nodata.oc "$OC" -O os9 -n Prog prog-0.out nodata.os9
run badformat.oc "$OC" -O nosuch prog.out bad.out
run badaddr.oc "$OC" -T 0x10000 prog.out bad.out
rm -f nodata.os9 bad.out

# programs run on sim6809: selftest.c calls code from control.c,
# switch.c, ptr.c and float.c and checks the results against the host compiler's,
# so its exit status is the number of failed checks; once as compiled,
# and once with every module compiled with -O
selfobjs="simcrt0.o selftest.o control.o switch.o ptr.o float.o"
link selftest	-m -M -T0x1000 $selfobjs -L"$LIBDIR" -lc
"$OC" -O srec selftest.out selftest.srec
"$SIM" -n 1000000 selftest.srec > selftest.run 2>&1
echo $? > selftest.run.rc
for f in selftest control switch ptr float; do
	run $f-O.c.cc "$BCC" -O -c -o $f-O.o $f.c
done
link selftest-O	-T0x1000 simcrt0.o selftest-O.o control-O.o switch-O.o ptr-O.o \
		float-O.o -L"$LIBDIR" -lc
"$OC" -O srec selftest-O.out selftest-O.srec
"$SIM" -n 1000000 selftest-O.srec > selftest-O.run 2>&1
echo $? > selftest-O.run.rc
rm -f selftest.srec selftest-O.srec selftest-O.out selftest-O.map \
	selftest-O.err selftest-O.rc

# OS-9's data model (bcc09 -Mo: code position-independent, data through
# U): os9data.c (whose assembly shows the code), selftest.c and the code
# it calls, fptest.c, ops.c and longops.c, built with -Mo and run with
# simcrt0.s, which sets U to 0, so that the data is where the linker put
# it; they call only helpers that keep U
run os9data-Mo.cc "$BCC" -Mo -S -o os9data-Mo.s os9data.c
for f in os9data selftest control switch ptr float fptest ops longops; do
	"$BCC" -Mo -c -o $f-Mo.o $f.c > /dev/null 2>&1
done
for f in os9data "selftest control switch ptr float" fptest ops longops; do
	set -- $f
	objs=
	for g in $f; do
		objs="$objs $g-Mo.o"
	done
	"$LD" -T0x1000 -o $1-Mo.out simcrt0.o $objs -L"$LIBDIR" -lc \
		> /dev/null 2>&1
	"$OC" -O srec $1-Mo.out $1-Mo.srec > /dev/null 2>&1
	"$SIM" -n 500000000 $1-Mo.srec > $1-Mo.run 2>&1
	echo $? >> $1-Mo.run
	rm -f $1-Mo.out $1-Mo.srec
done
rm -f *-Mo.o

# libc's run-time helpers: ops.c checks 16-bit multiply, divide,
# modulus and shifts (through the helpers, and the compiler's own code
# for constants) and memcpy against tables from tests/gen-opsdata.py;
# longops.c checks 32-bit long arithmetic, comparisons, shifts, unary
# operations, ++, -- and conversions against tables from
# tests/gen-longdata.py; fptest.c checks floating point arithmetic,
# comparisons, ++, -- and conversions against tables from
# tests/gen-fpdata.py; each exits with the number of failures;
# regtest.s checks that each helper leaves alone the registers the
# compiler relies on (and, for floating point, the stack)
link ops	-T0x1000 simcrt0.o ops.o -L"$LIBDIR" -lc
"$OC" -O srec ops.out ops.srec
"$SIM" -n 50000000 ops.srec > ops.run 2>&1
echo $? > ops.run.rc
link longops	-T0x1000 simcrt0.o longops.o -L"$LIBDIR" -lc
"$OC" -O srec longops.out longops.srec
"$SIM" -n 500000000 longops.srec > longops.run 2>&1
echo $? > longops.run.rc
run fptest.c.cc "$BCC" -c -o fptest.o fptest.c
link fptest	-T0x1000 simcrt0.o fptest.o -L"$LIBDIR" -lc
"$OC" -O srec fptest.out fptest.srec
"$SIM" -n 50000000 fptest.srec > fptest.run 2>&1
echo $? > fptest.run.rc
link regtest	-T0x1000 regtest.o -L"$LIBDIR" -lc
"$OC" -O srec regtest.out regtest.srec
"$SIM" -n 1000000 regtest.srec > regtest.run 2>&1
echo $? > regtest.run.rc
rm -f ops.srec longops.srec fptest.srec regtest.srec

# libc's C functions, mostly compiled by bcc09 from dev86's C: strtest.c
# checks string.h's, stdtest.c ctype.h's and stdlib.h's, maltest.c
# malloc and friends, and sbrk and brk, and vatest.c stdarg.h; each exits
# with the number of failures; each is also built for the host, with the
# host's C library, where it must print the same, which checks the
# expected results
hostcheck() {
	if ${CC:-cc} -std=gnu89 -w -o $1-host $1.c "$tests/host/putnum.c" \
		> /dev/null 2>&1 &&
	   ./$1-host > $1-host.run 2>&1 &&
	   sed '/^checks /,$d' $1.run > $1.cmp &&
	   sed '/^checks /,$d' $1-host.run > $1-host.cmp &&
	   cmp -s $1.cmp $1-host.cmp; then
		echo "ok   $1 prints the same results on the host"
	else
		echo "DIFF $1 on the host (see $1-host.run)"
	fi > $1-host.result
	rm -f $1-host $1-host.run $1.cmp $1-host.cmp
}
for f in strtest stdtest maltest vatest; do
	link $f	-T0x1000 simcrt0.o $f.o -L"$LIBDIR" -lc
	"$OC" -O srec $f.out $f.srec
	"$SIM" -n 50000000 $f.srec > $f.run 2>&1
	echo $? > $f.run.rc
	rm -f $f.srec
	hostcheck $f
done

# whole programs built by bcc09 alone, which links them with crt0 and
# libc, and run as a loader (loader.s) would run them: crtret.c checks
# that the BSS is cleared and returns 42; crtexit.c calls exit(7) from
# nested calls; crtatexit.c checks that returning from main calls the
# atexit() functions in the right order (21); loader.s checks that the
# stack pointer comes back, and exits with the status
for f in crtret crtexit crtatexit; do
	run $f.bcc "$BCC" -o $f.out -X-T0x1000 loader.s $f.c
	"$OC" -O srec $f.out $f.srec
	entry=$("$OD" -n $f.out | awk '$3 == "loader" { print $1 }')
	"$SIM" -n 1000000 --entry "0x$entry" $f.srec > $f.run 2>&1
	echo $? > $f.run.rc
	rm -f $f.srec
done

# programs for the sim6809 target (bcc09 -Mi), built by bcc09 alone and
# run as the simulator runs them, with f.in as the input if there is
# one: hello.c prints a line and returns 3; echo.c echoes its input in
# upper case, checks bad file descriptors and atexit(), and returns the
# number of lines; pftest.c prints a grid of printf formats, which must
# be the same with the host's printf; siotest.c checks stdio's FILE
# functions; chartest.c passes and returns chars with prototypes; sadd.c
# adds and subtracts ints and signed chars; sftest.c prints a grid of
# sscanf formats and inputs, and reads sftest.in with scanf, which must
# be the same with the host's scanf; fltcc.c uses floats and doubles in
# many ways; fpio.c prints and reads them (printf, strtod, scanf); mtest.c
# runs math.h's functions; inttest.c checks stdint.h and stdbool.h (cc1's
# _Bool); protoarg.c passes arguments of other types to prototyped
# functions; gltest.c reads gltest.in with getline() and getdelim();
# and a target with no start-up code yet can't be linked
for f in hello echo pftest siotest chartest sadd sftest fltcc fpio mtest inttest protoarg gltest; do
	run $f.bcc "$BCC" -Mi -o $f.out -X-T0x1000 $f.c
	"$OC" -O srec $f.out $f.srec
	input=/dev/null
	[ -f $f.in ] && input=$f.in
	"$SIM" -n 1000000000 $f.srec < $input > $f.run 2>&1
	echo $? > $f.run.rc
	rm -f $f.srec
done
# pftest.c, chartest.c, sadd.c, sftest.c, fltcc.c, fpio.c, mtest.c,
# inttest.c, protoarg.c and gltest.c must print the same with the host's
# compiler and C library (but for the count of checks, which differs);
# mtest.c with libc/math, the same
# fdlibm code built on the host, without fused multiply-adds or builtins,
# which must give the same results bit for bit
for f in pftest chartest sadd sftest fltcc fpio mtest inttest protoarg gltest; do
	input=/dev/null
	[ -f $f.in ] && input=$f.in
	extra=
	[ $f = mtest ] && extra="-fno-builtin -ffp-contract=off -I$top/libc/math $top/libc/math/*.c"
	if ${CC:-cc} -std=gnu89 -w -o $f-host $f.c $extra > /dev/null 2>&1 &&
	   ./$f-host < $input > $f-host.run 2>&1 &&
	   grep -v '^checks ' $f.run > $f.cmp &&
	   grep -v '^checks ' $f-host.run > $f-host.cmp &&
	   cmp -s $f.cmp $f-host.cmp; then
		echo "ok   $f prints the same as with the host's compiler"
	else
		echo "DIFF $f with the host's compiler (see $f-host.run)"
	fi > $f-host.result
	rm -f $f-host $f-host.run $f.cmp $f-host.cmp
done
# OS-9 modules (bcc09 -Mo: crtos9.o and libos9.a), made by objcopy09 and
# run by sim6809 --os9 at $0100 with the data area after the module:
# os9io.c, given the parameters "one two", checks the arguments, files
# (open, read, write, lseek, close, unlink and stdio's) and isatty;
# os9dir.c, malloc beyond the data area (F$Mem) and directories (mkdir,
# chdir, opendir, readdir; the directory it makes is removed after); and
# the programs above that the host's compiler checks, and hello.c, must
# run as they do on sim6809; not those that read lines (echo.c,
# sftest.c: OS-9's end with a CR, which libc passes on as it is),
# siotest.c (it closes fd 1, which OS-9 really closes) or mtest.c (too
# big for 64K with its data)
os9run() {	# $1 = name; the rest, sim6809's options
	f=$1
	shift
	input=/dev/null
	[ -f $f.in ] && input=$f.in
	"$BCC" -Mo -o $f-os9.out $f.c > /dev/null 2>&1
	"$OC" -O os9 -n $f $f-os9.out $f.mod > /dev/null 2>&1
	size=$(wc -c < $f.mod)
	"$SIM" -n 1000000000 --os9 --load 0x100 \
		--data $(( (0x100 + size + 255) / 256 * 256 )) "$@" $f.mod \
		< $input > $f-os9.run 2>&1
	echo $? > $f-os9.run.rc
	rm -f $f-os9.out $f.mod
}
os9run os9io --param "one two"
mv os9io-os9.run os9io.run
mv os9io-os9.run.rc os9io.run.rc
rm -rf os9dir.tmp
os9run os9dir
mv os9dir-os9.run os9dir.run
mv os9dir-os9.run.rc os9dir.run.rc
rm -rf os9dir.tmp
for f in hello pftest chartest sadd fltcc fpio inttest protoarg; do
	os9run $f
	if cmp -s $f.run $f-os9.run &&
	   cmp -s $f.run.rc $f-os9.run.rc; then
		echo "ok   $f runs the same as an OS-9 module"
	else
		echo "DIFF $f as an OS-9 module"
	fi
	rm -f $f-os9.run $f-os9.run.rc
done > os9.result

# floating point is optional: printf and scanf without it (pftest.out,
# sftest.out) carry none of its code, and fpio.out has it all: __fmtfp,
# __scanfp, strtod and the helpers
for f in pftest sftest fpio; do
	"$BCC" -Mi -o $f-opt.out -X-T0x1000 $f.c > /dev/null 2>&1
	printf "%s:" $f
	for s in ___fmtfp ___scanfp _strtod Fpushd; do
		"$OD" -n $f-opt.out | grep -q " T $s\$" && printf " %s" $s
	done
	echo
	rm -f $f-opt.out
done > fpoptional.result

# the Color BASIC target (bcc09 -Me): cbrom.s stands in for the ROM's
# POLCAT and CHROUT at $A000, and loader.s for EXEC; cbtest.c prints,
# reads lines from cbtest.in (with a rub-out) until BREAK, uses the heap
# and returns the number of lines
run cbrom.as "$AS" -o cbrom.o cbrom.s
"$LD" -T0xa000 -o cbrom.out cbrom.o
"$OC" -O srec cbrom.out cbrom.srec
run cbtest.bcc "$BCC" -Me -o cbtest.out -X-T0x3000 loader.s cbtest.c
"$OC" -O srec cbtest.out cbtest.srec
entry=$("$OD" -n cbtest.out | awk '$3 == "loader" { print $1 }')
grep -v '^S[059]' cbrom.srec | cat - cbtest.srec > cbtest-rom.srec
"$SIM" -n 50000000 --entry "0x$entry" cbtest-rom.srec < cbtest.in \
	> cbtest.run 2>&1
echo $? > cbtest.run.rc
# and Disk BASIC's files: cbdisk.s stands in for its ROM at $C000, with
# a disk of 4 free granules in memory; cbfile.c writes, reads, seeks,
# fills the disk, deletes and truncates, and prints the FAT's and the
# directory's bytes
run cbdisk.as "$AS" -o cbdisk.o cbdisk.s
"$LD" -T0xc000 -o cbdisk.out cbdisk.o
"$OC" -O srec cbdisk.out cbdisk.srec
run cbfile.bcc "$BCC" -Me -o cbfile.out -X-T0x3000 loader.s cbfile.c
"$OC" -O srec cbfile.out cbfile.srec
entry=$("$OD" -n cbfile.out | awk '$3 == "loader" { print $1 }')
grep -hv '^S[059]' cbrom.srec cbdisk.srec | cat - cbfile.srec > cbfile-rom.srec
"$SIM" -n 100000000 --entry "0x$entry" cbfile-rom.srec < /dev/null \
	> cbfile.run 2>&1
echo $? > cbfile.run.rc
rm -f cbrom.o cbrom.out cbrom.srec cbtest.srec cbtest-rom.srec cbdisk.o \
	cbdisk.out cbdisk.srec cbfile.srec cbfile-rom.srec

# the FLEX target (bcc09 -Mf): flexio.c, made a .CMD file by objcopy09
# and run by sim6809 --flex with the parameters "one,two three" (in FLEX's
# line buffer) and flexio.in as the terminal, prints its arguments,
# echoes lines in upper case, uses the heap, and returns the number of
# lines (sim6809's convention: B at WARMS)
run flexio.bcc "$BCC" -Mf -o flexio.out -X-T0x1000 flexio.c
"$OC" -O flex flexio.out FLEXIO.CMD
"$SIM" -n 50000000 --flex --param "one,two three" FLEXIO.CMD < flexio.in \
	> flexio.run 2>&1
echo $? > flexio.run.rc
rm -f FLEXIO.CMD

# copt's rules, checked by running code: each program above that runs
# on sim6809 is built again with -O (libc is always built with -O), and
# must give the same output and exit status as without
for f in ops longops fptest strtest stdtest maltest vatest; do
	"$BCC" -O -c -o $f-O.o $f.c > /dev/null 2>&1
	"$LD" -T0x1000 -o $f-O.out simcrt0.o $f-O.o -L"$LIBDIR" -lc \
		> /dev/null 2>&1
	"$OC" -O srec $f-O.out $f-O.srec > /dev/null 2>&1
	"$SIM" -n 500000000 $f-O.srec > $f-O.run 2>&1
	echo $? >> $f-O.run
	cat $f.run $f.run.rc > $f-plain.run
	if cmp -s $f-plain.run $f-O.run; then
		echo "ok   $f runs the same with -O"
	else
		echo "DIFF $f with -O"
	fi
	rm -f $f-O.o $f-O.out $f-O.srec $f-O.run $f-plain.run
done > optimize.result
for f in hello echo pftest siotest chartest sadd sftest fltcc fpio mtest inttest protoarg gltest; do
	"$BCC" -Mi -O -o $f-O.out -X-T0x1000 $f.c > /dev/null 2>&1
	"$OC" -O srec $f-O.out $f-O.srec > /dev/null 2>&1
	input=/dev/null
	[ -f $f.in ] && input=$f.in
	"$SIM" -n 1000000000 $f-O.srec < $input > $f-O.run 2>&1
	echo $? >> $f-O.run
	cat $f.run $f.run.rc > $f-plain.run
	if cmp -s $f-plain.run $f-O.run; then
		echo "ok   $f runs the same with -O"
	else
		echo "DIFF $f with -O"
	fi
	rm -f $f-O.out $f-O.srec $f-O.run $f-plain.run
done >> optimize.result

# the code mustn't depend on how long the headers' file names are (which
# the assembly's comments hold): fltcc.c and pftest.c, which cc1 once
# compiled with long branches for short ones at some of these lengths,
# are compiled through prefixes with names of 20 to 240 characters, and
# must give the same code (comments aside) as with ../prefix.tmp
for f in fltcc pftest; do
	"$BCC" -O -S -o $f-path.s $f.c > /dev/null 2>&1
	grep -v '^;' $f-path.s > $f-path.code
	differ=
	for len in 20 40 60 80 100 120 140 160 180 200 220 240; do
		long=$(printf 'p%.0s' $(seq 1 $len))
		ln -s ../prefix.tmp $long
		BCC_PREFIX=$long "$BCC" -O -S -o $f-path.s $f.c > /dev/null 2>&1
		grep -v '^;' $f-path.s | cmp -s - $f-path.code ||
			differ="$differ $len"
		rm -f $long
	done
	if [ -z "$differ" ]; then
		echo "ok   $f's code doesn't depend on the prefix's length"
	else
		echo "DIFF $f's code with prefixes of$differ characters"
	fi
	rm -f $f-path.s $f-path.code
done > pathlen.result

run notarget.bcc "$BCC" -Mv -o notarget.out hello.c
rm -f notarget.out

# the copied sources aren't results
for f in "$tests"/src/*; do
	rm -f "$(basename "$f")"
done
rm -rf "$prefix"

if [ $update = 1 ]; then
	rm -rf "$ref"
	mkdir -p "$ref"
	cp -p "$out"/* "$ref"/
	echo "updated $(ls "$ref" | wc -l) reference files"
	exit 0
fi

failed=0
for f in "$ref"/*; do
	name=$(basename "$f")
	if [ ! -f "$out/$name" ]; then
		echo "MISSING $name"
		failed=$((failed + 1))
	elif ! cmp -s "$f" "$out/$name"; then
		echo "FAIL    $name"
		failed=$((failed + 1))
	fi
done
for f in "$out"/*; do
	name=$(basename "$f")
	if [ ! -f "$ref/$name" ]; then
		echo "NEW     $name (not in ref/)"
		failed=$((failed + 1))
	fi
done

total=$(ls "$ref" | wc -l)
if [ $failed = 0 ]; then
	echo "all $total test files match"
	exit 0
fi
echo "$failed of $total test files differ (outputs are in $out)"
exit 1
