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
ln -s "$top/libc/libc.a" "$prefix/lib/bcc09/"
LIBDIR=$prefix/lib/bcc09
export BCC_PREFIX=$prefix
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
csrc="arith calls control float helpmain long longops main ops proto ptr
      selftest struct switch"
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
# and with libc: what it doesn't have yet
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
for f in binary srec ihex decb ddos cas wav; do
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
# objcopy09 errors: no OS-9 data size; a bad format name; an address
# that doesn't fit in 16 bits
run os9-nodata.oc "$OC" -O os9 -n Prog prog-0.out nodata.os9
run badformat.oc "$OC" -O nosuch prog.out bad.out
run badaddr.oc "$OC" -T 0x10000 prog.out bad.out
rm -f nodata.os9 bad.out

# programs run on sim6809: selftest.c calls code from control.c,
# switch.c and ptr.c and checks the results against the host compiler's,
# so its exit status is the number of failed checks; once as compiled,
# and once with every module compiled with -O
selfobjs="simcrt0.o selftest.o control.o switch.o ptr.o"
link selftest	-m -M -T0x1000 $selfobjs
"$OC" -O srec selftest.out selftest.srec
"$SIM" -n 1000000 selftest.srec > selftest.run 2>&1
echo $? > selftest.run.rc
for f in selftest control switch ptr; do
	run $f-O.c.cc "$BCC" -O -c -o $f-O.o $f.c
done
link selftest-O	-T0x1000 simcrt0.o selftest-O.o control-O.o switch-O.o ptr-O.o
"$OC" -O srec selftest-O.out selftest-O.srec
"$SIM" -n 1000000 selftest-O.srec > selftest-O.run 2>&1
echo $? > selftest-O.run.rc
rm -f selftest.srec selftest-O.srec selftest-O.out selftest-O.map \
	selftest-O.err selftest-O.rc

# libc's run-time helpers: ops.c checks 16-bit multiply, divide,
# modulus and shifts (through the helpers, and the compiler's own code
# for constants) and memcpy against tables from tests/gen-opsdata.py;
# longops.c checks 32-bit long arithmetic, comparisons, shifts, unary
# operations, ++, -- and conversions against tables from
# tests/gen-longdata.py; each exits with the number of failures;
# regtest.s checks that each helper leaves alone the registers the
# compiler relies on
link ops	-T0x1000 simcrt0.o ops.o -L"$LIBDIR" -lc
"$OC" -O srec ops.out ops.srec
"$SIM" -n 50000000 ops.srec > ops.run 2>&1
echo $? > ops.run.rc
link longops	-T0x1000 simcrt0.o longops.o -L"$LIBDIR" -lc
"$OC" -O srec longops.out longops.srec
"$SIM" -n 500000000 longops.srec > longops.run 2>&1
echo $? > longops.run.rc
link regtest	-T0x1000 regtest.o -L"$LIBDIR" -lc
"$OC" -O srec regtest.out regtest.srec
"$SIM" -n 1000000 regtest.srec > regtest.run 2>&1
echo $? > regtest.run.rc
rm -f ops.srec longops.srec regtest.srec

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
