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

# sim6809 runs the test programs: the sim6809 project's
# (https://github.com/retrotinker/sim6809), from PATH, or $SIM6809
SIM=${SIM6809:-sim6809}
if ! command -v "$SIM" > /dev/null 2>&1; then
	echo "run.sh: no $SIM: the tests need sim6809, from" \
	     "https://github.com/retrotinker/sim6809 (or set SIM6809)" >&2
	exit 2
fi
# (1.2.0 or later: os9path.c needs its OS-9 directories)
case $("$SIM" --version 2>/dev/null | awk '{ print $2 }') in
0.*|1.0.*|1.1.*|"")
	echo "run.sh: $SIM is too old: the tests need sim6809 1.2.0 or" \
	     "later, from https://github.com/retrotinker/sim6809" >&2
	exit 2 ;;
esac

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
mkdir -p "$prefix/share/bcc09"
ln -s "$top/libc/libc.a" "$top/libc/include" "$top/libc/crt0.o" \
	"$top/libc/libsa.a" "$top/libc/libcb.a" "$top/libc/crtsim.o" \
	"$top/libc/libsim.a" "$top/libc/crtos9.o" "$top/libc/libos9.a" \
	"$top/libc/crtflex.o" "$top/libc/libflex.a" "$top/libc/crtrom.o" \
	"$top/libc/librom.a" "$top/libc/rom/rom.ld" "$top/libc/crtvec.o" \
	"$top/libc/libvec.a" "$top/libc/vec/vectrex.ld" \
	"$prefix/share/bcc09/"
LIBDIR=$prefix/share/bcc09
# (the same, relative to $out, for links whose maps name the library)
LIBREL=../prefix.tmp/share/bcc09
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
      struct switch vatest direct asmseg"
for f in $csrc; do
	run $f.cc "$BCC" -S -o $f.s $f.c
	run $f-O.cc "$BCC" -O -S -o $f-O.s $f.c
	run $f.c.cc "$BCC" -c -o $f.o $f.c
done
# __direct variables with data through U (-Mo): their values as <name,
# their addresses still name,U
run direct-u.cc "$BCC" -Mo -S -o direct-u.s direct.c
# compiler errors
run syntax.cc "$BCC" -S -o syntax.s syntax.c
rm -f syntax.s
run directerr.cc "$BCC" -S -o directerr.s directerr.c
rm -f directerr.s

# the assembler: object file, listing and symbol file
for f in crt0 modes regtest simcrt0 os9op; do
	run $f.as "$AS" -o $f.o -l $f.lst -s $f.sym $f.s
done
# OS9's errors
run os9err.as "$AS" -o os9err.o os9err.s
rm -f os9err.o
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
# ar09's operations: the member list after each (adding at a position,
# appending, deleting, and moving: before the first, after another, to
# the end, one already last, several, and in a one-member archive, which
# once looped without end), and extraction, which must give back the
# objects; each with a time and size limit, in case of such a loop
(
	ulimit -f 4096
	ar() { timeout 10 "$AR" "$@" 2>&1; }
	list() { echo "$1: $(ar t arops.a | tr '\n' ' ')"; }
	rm -f arops.a arone.a
	ar rc arops.a main.o ptr.o;		list "rc main ptr"
	ar ra main.o arops.a control.o;		list "ra main control"
	ar rb main.o arops.a crt0.o;		list "rb main crt0"
	ar d arops.a crt0.o;			list "d crt0"
	ar q arops.a crt0.o;			list "q crt0"
	ar mb main.o arops.a crt0.o;		list "mb main crt0"
	ar ma control.o arops.a crt0.o;		list "ma control crt0"
	ar m arops.a main.o;			list "m main"
	ar m arops.a main.o;			list "m main (already last)"
	ar mb ptr.o arops.a main.o crt0.o;	list "mb ptr main crt0"
	ar rc arone.a main.o
	ar m arone.a main.o
	echo "one member, m: $(ar t arone.a | tr '\n' ' ')"
	# s: accepted (no symbol table: ld09 needs none); alone, only that
	# the archive is there
	ar rcs arone.a ptr.o
	echo "rcs ptr: $(ar t arone.a | tr '\n' ' ')"
	ar s arone.a; echo "s arone.a: status $?"
	ar s nosuch.a > /dev/null; echo "s nosuch.a: status $?"
	mkdir arx && cd arx && ar x ../arops.a
	for f in main.o control.o ptr.o crt0.o; do
		cmp -s $f ../$f && echo "x $f: the same" || echo "x $f: DIFFERS"
	done
	cd .. && rm -rf arx arops.a arone.a
) > arops.result 2>&1

# the linker: the test program, from objects and from the library, with
# maps; stripped; headerless; with separate data; at address 0 (for
# OS-9)
link prog	-m -M -T0x1000 crt0.o main.o control.o ptr.o
link prog-lib	-m -M -T0x1000 -L. crt0.o main.o -ltest
link prog-s	-s -T0x1000 crt0.o main.o control.o ptr.o
link prog-d	-d -T0x1000 crt0.o main.o control.o ptr.o
link prog-D	-m -M -T0x1000 -D0x4000 crt0.o main.o control.o ptr.o
link prog-L	-m -M -T0x4000 -D0x1000 crt0.o main.o control.o ptr.o
link prog-0	-T0 crt0.o main.o control.o ptr.o
# a symbol a library member defines again: no warning if the member
# isn't linked (a program's own version of a library function); a
# warning if something else needs the member
for f in redefmain redefboth redeflib; do
	"$AS" -o $f.o $f.s > /dev/null 2>&1
done
"$AR" rc libredef.a redeflib.o
link redef-quiet	-m -T1000 redefmain.o -L. -lredef
link redef-both	-m -T1000 redefboth.o -L. -lredef
rm -f redefmain.o redefboth.o redeflib.o libredef.a
# a common block that a library member has too: not a reason to link
# the member (it was, for scanfp.o's __opreg, into FLEX programs with
# files); a member that is linked for something else, and its common
# block the same as the program's; and an import that only the member's
# common block satisfies, which links it
for f in commmain commneed commref commlib; do
	"$AS" -o $f.o $f.s > /dev/null 2>&1
done
"$AR" rc libcomm.a commlib.o
link comm-quiet	-m -M -T1000 commmain.o -L. -lcomm
link comm-need	-m -M -T1000 commneed.o -L. -lcomm
link comm-ref	-m -M -T1000 commref.o -L. -lcomm
# an import under another counter than the member's common block (a bare
# import's counter is only what its module assumed): the common block
# wins, with a warning naming both counters, read first or last (with
# the import first, the symbol was undefined)
"$AS" -o commseg.o commseg.s > /dev/null 2>&1
link comm-seg	-m -M -T1000 -L. -lcomm commseg.o
link comm-seg2	-m -M -T1000 commseg.o -L. -lcomm
rm -f commmain.o commneed.o commref.o commlib.o commseg.o libcomm.a
# an import under another counter than its definition (impuse.s,
# impdef.s), and of an EQU constant: the definitions win, either order,
# with a warning for the variable (ld01's rule; before, with the import
# first, the symbol was undefined)
for f in impuse impdef; do
	"$AS" -o $f.o $f.s > /dev/null 2>&1
done
link imp-ab	-m -M -T1000 impuse.o impdef.o
link imp-ba	-m -M -T1000 impdef.o impuse.o
rm -f impuse.o impdef.o
# a variable a module imports in the direct page (C's extern __direct),
# which another defines elsewhere: an error, whichever is read first
for f in directuse directdef; do
	"$BCC" -c -o $f.o $f.c > /dev/null 2>&1
done
link direct-ud	-T1000 directuse.o directdef.o
link direct-du	-T1000 directdef.o directuse.o
rm -f directuse.o directdef.o direct-ud.out direct-du.out
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

# linker scripts (ld09 -S), with the scripts and sources in
# tests/scripts (copied here, so messages name them without a path):
# ld01's tests, from mc6801-tools, for the 6809
for f in "$tests"/scripts/*; do
	cp "$f" .
done
for f in segs helper usesym page romcrt romvec romstart vectors noload \
	 mainent; do
	"$AS" -o $f.o $f.s > /dev/null 2>&1 || echo "$f.s doesn't assemble"
done > scripts-as.result
link custom	-m -M -S custom.ld usesym.o segs.o helper.o
link custom-A	-m -M -S custom.ld -A __heap_top=0x6000 -A extra=7 \
		usesym.o segs.o helper.o
"$OD" -n custom.out > custom.nm	# __heap_top: a long script symbol
link orphan	-m -M -S orphan.ld segs.o helper.o
link orphan-Z	-Z -S orphan.ld segs.o helper.o
link orphan2	-m -M -S orphan2.ld segs.o helper.o
for f in syntax undef overlap range both settle entry unknown; do
	link err-$f -S err-$f.ld segs.o helper.o
done
link err-onepage -S err-onepage.ld page.o

# a ROM: MEMORY, AT>, NOLOAD, KEEP, FILL, BYTE, WORD, ASSERT, INCLUDE,
# the __name_load symbols, and S-record and Intel hex output; and ld09(1)'s
# example
link rom	-m -M -S rom.ld romcrt.o romvec.o segs.o helper.o
link rom-srec	-S rom-srec.ld romcrt.o romvec.o segs.o helper.o
link rom-ihex	-S rom-ihex.ld romcrt.o romvec.o segs.o helper.o
link example	-m -M -S example.ld romstart.o vectors.o
sed -n '/^ENTRY(reset)/,/^}/p' example.ld > example.script
{ sed -n '/^ENTRY(reset)/,/^}/p' "$top/doc/man/ld09.1" | sed 's/\\-/-/g' |
	cmp -s - example.script &&
	echo "ok   example.ld is ld09(1)'s example" ||
	echo "DIFF example.ld and ld09(1)'s example"
} > example.result
rm -f example.script
link bss	-m -M -S bss.ld segs.o helper.o
link err-assert	-S rom-nokeep.ld romcrt.o romvec.o segs.o helper.o
for f in at-aout region noregion lmaoverlap; do
	link err-$f -S err-$f.ld segs.o helper.o
done

# initialized data in a NOLOAD section, which isn't written, is an
# error (once for each module and counter); reserved space isn't, and
# BYTE or WORD there is a script error
link err-noload	-S err-noload.ld noload.o
link noload-ok	-m -M -S noload-ok.ld noload.o
link err-noload-byte	-S err-noload-byte.ld noload.o

# EXCLUDE_FILE: the ROM with the vector table's section after .text,
# which excludes it, gives the same output as rom.ld; input that a
# section excludes and nothing else takes is an orphan, placed after a
# section that takes all files; and two syntax errors
link rom-excl	-m -M -S rom-excl.ld romcrt.o romvec.o segs.o helper.o
if cmp -s rom.out rom-excl.out; then
	echo "ok   rom-excl.out is the same as rom.out"
else
	echo "DIFF rom-excl.out and rom.out"
fi > excl.result
link excl-orphan	-m -M -S excl-orphan.ld segs.o helper.o
for f in excl1 excl2; do
	link err-$f -S err-$f.ld segs.o helper.o
done

# a C program with a script that names only the sections: ld09 provides
# the symbols libc's start-up code and objcopy09 need, and it runs; with
# segment 5 (the init functions) split, __seg5DL can't be provided
run splitprog.bcc "$BCC" -Mi -o splitprog.out -X-Ssplit.ld splitprog.c
"$OD" -n splitprog.out | grep ' __[be]\| __seg5\| __end' > splitprog.nm
"$OC" -O srec splitprog.out splitprog.srec > /dev/null 2>&1
"$SIM" splitprog.srec > splitprog.run 2>&1
echo $? > splitprog.run.rc
rm -f splitprog.out splitprog.srec
run err-seg5.bcc "$BCC" -Mi -o err-seg5.out -X-Serr-seg5.ld splitprog.c
rm -f err-seg5.out
# no ENTRY: _main
link mainent	-m -M mainent.o

# the default script, as -P prints it, and linking with it: the output
# must be the same as without a script, with or without the options it
# was printed for (as bcc09's targets link: -Mo with -i, at 0)
"$LD" -P > default.ld 2> default.err
echo $? > default.rc
"$LD" -P -S custom.ld > p-and-s.out 2> p-and-s.err
echo $? > p-and-s.rc
roundtrip() {
	rt=rt-$1	# (link() uses $name)
	shift
	link "$rt" "$@" $objs
	"$LD" -P "$@" > "$rt-P.ld"
	link "$rt-P" -S "$rt-P.ld" "$@" $objs
	link "$rt-Ponly" -S "$rt-P.ld" $flags $objs
	for v in P Ponly; do
		if cmp -s "$rt.out" "$rt-$v.out" &&
		   cmp -s "$rt.map" "$rt-$v.map" &&
		   cmp -s "$rt.rc" "$rt-$v.rc"; then
			echo "ok   $rt-$v"
		else
			echo "DIFF $rt-$v"
		fi
		rm -f "$rt-$v.out" "$rt-$v.map" "$rt-$v.err" "$rt-$v.rc"
	done >> roundtrip.result
	rm -f "$rt.out" "$rt.map" "$rt.err" "$rt.rc" "$rt-P.ld"
}
rm -f roundtrip.result
objs="segs.o helper.o" flags="-m -M"
roundtrip segs -m -M -T0
roundtrip segs-TD -m -M -T1000 -D8000
flags="-m -M -i"
roundtrip segs-i -m -M -i -T1000
flags="-m -M"
roundtrip segs-H -m -M -Te000 -H100
flags="-d"
roundtrip segs-d -d -Te000
flags="-m -M"
roundtrip segs-odd -m -M -T1001 -D8003
objs="page.o"
roundtrip page -m -M -T0
objs="crt0.o main.o control.o ptr.o"
roundtrip prog -m -M -T1000
# and as bcc09 links for sim6809 (-Mi) and OS-9 (-Mo, with -i)
"$BCC" -c -o hello-rt.o hello.c > /dev/null 2>&1
"$BCC" -Mo -c -o hello-rt-Mo.o hello.c > /dev/null 2>&1
objs="-L$LIBDIR -Csim hello-rt.o -lc -lsim"
roundtrip hello-Mi -m -M -T100
flags="-m -M -i"
objs="-L$LIBDIR -Cos9 hello-rt-Mo.o -los9"
roundtrip hello-Mo -m -M -i
rm -f hello-rt.o hello-rt-Mo.o

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
# objcopy09: the data below the code (prog-L.out, -T0x4000 -D0x1000):
# S-records and DECB, a block each; and with -p, the formats of one
# block (binary, cas, ddos) hold one image from the data's address, the
# gap zeros; without -p, cas refuses; and code and data that overlap
run prog-Lsrec.oc "$OC" -O srec -n PROG prog-L.out prog-L.srec
run prog-Ldecb.oc "$OC" -O decb prog-L.out prog-L.decb
run prog-Lp.oc "$OC" -O binary -p prog-L.out prog-Lp.binary
run prog-Lcas.oc "$OC" -O cas -p -n PROG prog-L.out prog-L.cas
run prog-Lddos.oc "$OC" -O ddos -p prog-L.out prog-L.ddos
run prog-Lnop.oc "$OC" -O cas -n PROG prog-L.out bad.out
run overlap.oc "$OC" -O binary -p -T 0x1000 -D 0x1004 prog-D.out bad.out
rm -f bad.out

# programs run on sim6809: selftest.c calls code from control.c,
# switch.c, ptr.c and float.c and checks the results against the host compiler's,
# so its exit status is the number of failed checks; once as compiled,
# and once with every module compiled with -O
selfobjs="simcrt0.o selftest.o control.o switch.o ptr.o float.o"
link selftest	-m -M -T0x1000 $selfobjs -L"$LIBREL" -lc
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
# dpret.c has __direct variables, so its start-up code sets DP to their
# page; dploader.s calls it with DP $5A, which it must give back (98 if
# not): exit status 42
run dpret.bcc "$BCC" -o dpret.out -X-T0x1000 dploader.s dpret.c
"$OC" -O srec dpret.out dpret.srec
entry=$("$OD" -n dpret.out | awk '$3 == "loader" { print $1 }')
"$SIM" -n 1000000 --entry "0x$entry" dpret.srec > dpret.run 2>&1
echo $? > dpret.run.rc
rm -f dpret.srec

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
# dptest.c uses __direct variables (DP their page); and a target with no
# start-up code yet can't be linked
for f in hello echo pftest siotest chartest sadd sftest fltcc fpio mtest inttest protoarg gltest \
	 atexitio dptest; do
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
# rmdir() and getcwd(), which OS-9 has no calls for (os9path.c): sim6809
# (1.2.0) emulates what they use as NitrOS-9 has it (the D attribute,
# I$Delete of a directory, the entries' LSNs, the device's name), and
# make check-nitros9 runs it there too, for the same output
rm -rf QA QF
os9run os9path
mv os9path-os9.run os9path.run
mv os9path-os9.run.rc os9path.run.rc
rm -rf QA QF
for f in hello pftest chartest sadd fltcc fpio inttest protoarg dptest; do
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
# the programs in doc/basic.md (bcc09 for BASIC Programmers): each
# complete one (with a main) must compile and link for Color BASIC
awk '/^```c$/ { n++; f = sprintf("basic%02d.c", n); b = 1; next }
     /^```$/ { b = 0; next }
     b { print > f }' "$top/doc/basic.md"
for f in basic[0-9]*.c; do
	if grep -q 'main()' $f; then
		if "$BCC" -Me -O -o basic.out -X-T0x3000 $f > basic.err 2>&1; then
			echo "ok   $f compiles and links"
		else
			echo "FAIL $f:"
			cat basic.err
		fi
	fi
	rm -f $f basic.out basic.err
done > basic.result
# and those in doc/vectrex.md (bcc09 for Vectrex Programmers), as
# Vectrex cartridges; the others, functions alone, must compile, and its
# assembly (a block that starts with a comment) must assemble
awk 'mode == "" && /^```c$/ { n++; f = sprintf("vecdoc%02d.c", n)
				 mode = "c"; next }
     mode == "" && /^```$/ { mode = "first"; next }
     mode != "" && /^```$/ { mode = ""; next }
     mode == "first" { if (/^;/) { n++; f = sprintf("vecdoc%02d.s", n)
				   mode = "s" } else mode = "other" }
     mode == "c" || mode == "s" { print > f }' "$top/doc/vectrex.md"
for f in vecdoc[0-9]*.[cs]; do
	if [ "${f%.s}" != "$f" ]; then
		cmd="$AS -o vecdoc.o $f"
	elif grep -q 'main()' $f; then
		cmd="$BCC -Mv -O -o vecdoc.bin $f"
	else
		cmd="$BCC -Mv -O -c -o vecdoc.o $f"
	fi
	if $cmd > vecdoc.err 2>&1; then
		echo "ok   $f"
	else
		echo "FAIL $f:"
		cat vecdoc.err
	fi
	rm -f $f vecdoc.bin vecdoc.o vecdoc.err
done > vecdoc.result
# and those in doc/os9.md (bcc09 for OS-9 Programmers), as OS-9
# modules: its assembly first, which a program may call
awk 'mode == "" && /^```c$/ { n++; f = sprintf("os9doc%02d.c", n)
				 mode = "c"; next }
     mode == "" && /^```$/ { mode = "first"; next }
     mode != "" && /^```$/ { mode = ""; next }
     mode == "first" { if (/^;/) { n++; f = sprintf("os9doc%02d.s", n)
				   mode = "s" } else mode = "other" }
     mode == "c" || mode == "s" { print > f }' "$top/doc/os9.md"
{
	for f in os9doc[0-9]*.s; do
		if "$AS" -o ${f%.s}.o $f > os9doc.err 2>&1; then
			echo "ok   $f"
		else
			echo "FAIL $f:"
			cat os9doc.err
		fi
	done
	for f in os9doc[0-9]*.c; do
		if grep -q 'main(' $f; then
			cmd="$BCC -Mo -O -o os9doc.out $f $(ls os9doc[0-9]*.o)"
		else
			cmd="$BCC -Mo -O -c -o os9doc.o $f"
		fi
		if $cmd > os9doc.err 2>&1; then
			echo "ok   $f"
		else
			echo "FAIL $f:"
			cat os9doc.err
		fi
	done
} > os9doc.result
rm -f os9doc[0-9]*.[cso] os9doc.out os9doc.o os9doc.err
# and those in doc/flex.md (bcc09 for FLEX Programmers), as FLEX
# commands, the same way
awk 'mode == "" && /^```c$/ { n++; f = sprintf("flexdoc%02d.c", n)
				 mode = "c"; next }
     mode == "" && /^```$/ { mode = "first"; next }
     mode != "" && /^```$/ { mode = ""; next }
     mode == "first" { if (/^;/) { n++; f = sprintf("flexdoc%02d.s", n)
				   mode = "s" } else mode = "other" }
     mode == "c" || mode == "s" { print > f }' "$top/doc/flex.md"
{
	for f in flexdoc[0-9]*.s; do
		if "$AS" -o ${f%.s}.o $f > flexdoc.err 2>&1; then
			echo "ok   $f"
		else
			echo "FAIL $f:"
			cat flexdoc.err
		fi
	done
	for f in flexdoc[0-9]*.c; do
		if grep -q 'main(' $f; then
			cmd="$BCC -Mf -O -o flexdoc.out -X-T0x1000 $f $(ls flexdoc[0-9]*.o)"
		else
			cmd="$BCC -Mf -O -c -o flexdoc.o $f"
		fi
		if $cmd > flexdoc.err 2>&1; then
			echo "ok   $f"
		else
			echo "FAIL $f:"
			cat flexdoc.err
		fi
	done
} > flexdoc.result
rm -f flexdoc[0-9]*.[cso] flexdoc.out flexdoc.o flexdoc.err
# FAQ.md is the manual's chapter "Questions and answers" on its own
# (doc/mkfaq.sh makes it): it must be what the manual has now
if "$top/doc/mkfaq.sh" -c; then
	echo "ok   FAQ.md is the manual's chapter 10"
else
	echo "DIFF FAQ.md isn't the manual's chapter 10: run make docs"
fi > faq.result
# coco.h's functions: cls(), locate(), joystk(), inkey(), peek(), poke()
run cocotest.bcc "$BCC" -Me -o cocotest.out -X-T0x3000 loader.s cocotest.c
"$OC" -O srec cocotest.out cocotest.srec
entry=$("$OD" -n cocotest.out | awk '$3 == "loader" { print $1 }')
grep -v '^S[059]' cbrom.srec | cat - cocotest.srec > cocotest-rom.srec
"$SIM" -n 50000000 --entry "0x$entry" cocotest-rom.srec < cocotest.in \
	> cocotest.run 2>&1
echo $? > cocotest.run.rc
rm -f cocotest.srec cocotest-rom.srec
# doc/worm.c, the example game, played with cbrom.s standing in for the
# ROM (whose POLCAT gives no key every other call, and BREAK at the end
# of the input: worm.in's keys come on every other move, so the worm
# can't reach the food here; it turns up into the wall, ENTER plays
# again, and the end of the input BREAKs that game and stops); what it
# prints (the title, the scores, GAME OVER) must be the same.  make
# check-xroar plays it on the real ROMs, eating, and checks the board.
run worm.bcc "$BCC" -Me -O -o worm.out -X-T0x3000 loader.s "$top/doc/worm.c"
"$OC" -O srec worm.out worm.srec
entry=$("$OD" -n worm.out | awk '$3 == "loader" { print $1 }')
grep -v '^S[059]' cbrom.srec | cat - worm.srec > worm-rom.srec
"$SIM" -n 50000000 --entry "0x$entry" worm-rom.srec < worm.in > worm.run 2>&1
echo $? > worm.run.rc
rm -f worm.out worm.srec worm-rom.srec
# coco.h's sound(), traced: its writes to the DAC ($FF20), counted, must
# be $7E, $FE, $7E, $02 in turn, and each period (from a write to the
# fourth after it, of the same tone, in B) must take BASIC's 100 + 20 *
# (256 - tone) cycles (sim6809's CYC=), but where a fifteenth of a second
# ends and sound() calls the loop again (the program prints the rest)
run soundtest.bcc "$BCC" -Me -o soundtest.out -X-T0x3000 loader.s soundtest.c
"$OC" -O srec soundtest.out soundtest.srec
entry=$("$OD" -n soundtest.out | awk '$3 == "loader" { print $1 }')
grep -v '^S[059]' cbrom.srec | cat - soundtest.srec > soundtest-rom.srec
"$SIM" -t -n 5000000 --entry "0x$entry" soundtest-rom.srec < /dev/null \
	> soundtest.run 2> soundtest.trace
echo $? > soundtest.run.rc
awk 'function field(name,   i) {
	i = index($0, name "=")
	return substr($0, i + length(name) + 1)
     }
     function hex(s,   i, v) {	# (strtonum is gawk'"'"'s)
	v = 0
	for (i = 1; i <= length(s); i++)
		v = v * 16 + index("0123456789ABCDEF", substr(s, i, 1)) - 1
	return v
     }
     /STA   \$FF20 / {
	a = substr(field("A"), 1, 2)
	t = hex(substr(field("B"), 1, 2))
	c = field("CYC") + 0
	if (a != pat[n % 4]) bad++
	if (n >= 4 && tone[n - 4] == t) {
		if (n % 4 == 0) {
			if (c - cyc[n - 4] == 100 + 20 * (256 - t))
				exact[t]++
			else
				longer[t]++
		}
	}
	tone[n] = t
	cyc[n] = c
	n++
     }
     BEGIN { n = 0; pat[0] = "7E"; pat[1] = "FE"; pat[2] = "7E"; pat[3] = "02" }
     END {
	printf "%d writes to the DAC, %s\n", n,
	       bad ? bad " out of turn" : "in turn"
	for (t = 0; t < 256; t++)
		if (t in exact)
			printf "tone %d: %d periods of %d cycles, %d longer\n",
			       t, exact[t], 100 + 20 * (256 - t), longer[t]
     }' soundtest.trace > soundtest.dac
rm -f soundtest.srec soundtest-rom.srec soundtest.trace

# a Color BASIC ROM cartridge (bcc09 -Mr): rom.ld, with S-record output
# for sim6809, which starts it at $C000 with cbrom.s: crtrom.o copies
# the initialized data to RAM and clears the BSS; romtest.c reads lines
# until BREAK, and its atexit() function runs before _exit() stops in
# its loop (so the run ends at the instruction limit, in __exit's loop)
printf 'INCLUDE "%s"\nOUTPUT_FORMAT(srec)\n' "$LIBREL/rom.ld" > romsrec.ld
run romtest.bcc "$BCC" -Mr -o romtest.srec -X-Sromsrec.ld romtest.c
grep -v '^S[059]' cbrom.srec | cat - romtest.srec > romtest-rom.srec
"$SIM" -n 20000000 --entry 0xC000 romtest-rom.srec < romtest.in \
	> romtest.run 2>&1
echo $? > romtest.run.rc
# (where it stopped: _exit's loop, 2 bytes after __exit, from a map)
"$BCC" -Mr -o romtest-map.srec -X-Sromsrec.ld -X-M romtest.c \
	> romtest.map 2>&1
stop=$(awk '$2 == "__exit" { print $4 }' romtest.map)
stop=$(printf '%04X' $((0x$stop + 2)))
sed -i "s/ reached at PC=$stop\$/ reached, in _exit's loop/" romtest.run
rm -f romtest.map romtest-map.srec
# and its image: 16K less the last page (8K for a smaller program), from
# crtrom.o's code at $C000 (ORCC #$50, LDS), filled out with $FF
run rom.bcc "$BCC" -Mr -o romtest.rom romtest.c
{ echo "$(wc -c < romtest.rom) bytes"
  od -An -tx1 -N4 romtest.rom
  tail -c 4 romtest.rom | od -An -tx1; } > romtest.img
# __direct variables in a cartridge: romdp.c, with DP their page, in RAM,
# both the initialized ones and a common block (not in .bss's COMMON)
run romdp.bcc "$BCC" -Mr -o romdp.srec -X-Sromsrec.ld romdp.c
grep -v '^S[059]' cbrom.srec | cat - romdp.srec > romdp-rom.srec
"$SIM" -n 2000000 --entry 0xC000 romdp-rom.srec < /dev/null > romdp.run 2>&1
"$BCC" -Mr -o romdp-map.srec -X-Sromsrec.ld -X-M romdp.c 2>&1 |
	awk '$2 == "_init" || $2 == "_bss" || $2 == "_word"' > romdp.syms
sed -i 's/ reached at PC=[0-9A-F]*$/ reached/' romdp.run
rm -f romdp.srec romdp-rom.srec romdp-map.srec
rm -f romsrec.ld romtest.srec romtest-rom.srec romtest.rom

# a Vectrex cartridge (bcc09 -Mv): vectrex.ld, with S-record output,
# and vecbios.s for the BIOS (linked at 0, with labels from $F000 up:
# only its records from there are kept), which prints each call with
# its registers and DP; run from crtvec.o's start, after the header, to
# _exit()'s loop (2 bytes after __exit), where the instruction limit
# ends it
printf 'INCLUDE "%s"\nOUTPUT_FORMAT(srec)\n' "$LIBREL/vectrex.ld" > vecsrec.ld
run vectest.bcc "$BCC" -Mv -o vectest.srec -X-Svecsrec.ld vectest.c
"$BCC" -Mv -o vectest-map.srec -X-Svecsrec.ld -X-M vectest.c \
	> vectest.map 2>&1
run vecbios.as "$AS" -o vecbios.o vecbios.s
"$LD" -T0 -o vecbios.out vecbios.o
"$OC" -O srec vecbios.out vecbios.srec 2> /dev/null
start=$(grep -a ' crt0 *start ' vectest.map | awk '{ print substr($4, 5) }')
stop=$(grep -a ' __exit ' vectest.map | awk '{ print $4 }')
stop=$(printf '%04X' $((0x$stop + 2)))
awk 'substr($0, 1, 2) == "S1" && substr($0, 5, 4) >= "F000"' vecbios.srec |
	cat - vectest.srec > vectest-all.srec
"$SIM" -n 2000000 --entry "0x$start" vectest-all.srec > vectest.run 2>&1
echo $? > vectest.run.rc
sed -i "s/ reached at PC=$stop\$/ reached, in _exit's loop/" vectest.run
# and its image: the header at $0000 ("g GCE"), then the code; and with
# a header of its own (vectitle.s), with no warning about libvec.a's
run vec.bcc "$BCC" -Mv -o vectest.bin vectest.c
{ echo "$(wc -c < vectest.bin) bytes"
  od -An -c -N24 vectest.bin; } > vectest.img
run vectitle.bcc "$BCC" -Mv -o vectitle.bin vectest.c vectitle.s
od -An -c -N26 vectitle.bin > vectitle.img
rm -f vectitle.bin
# doc/rocks.c, the example game (played in MAME by make check-vectrex):
# its header, from asm() in C, at $0000, with its title
run rocks.bcc "$BCC" -Mv -O -o rocks.bin "$top/doc/rocks.c"
od -An -c -N24 rocks.bin > rocks.img
rm -f rocks.bin
# __direct variables in a cartridge: vecdp.c runs with DP $C8, their page,
# and the BIOS still gets its own
run vecdp.bcc "$BCC" -Mv -o vecdp.srec -X-Svecsrec.ld vecdp.c
"$BCC" -Mv -o vecdp-map.srec -X-Svecsrec.ld -X-M vecdp.c > vecdp.map 2>&1
start=$(grep -a ' crt0 *start ' vecdp.map | awk '{ print substr($4, 5) }')
stop=$(grep -a ' __exit ' vecdp.map | awk '{ print $4 }')
stop=$(printf '%04X' $((0x$stop + 2)))
awk 'substr($0, 1, 2) == "S1" && substr($0, 5, 4) >= "F000"' vecbios.srec |
	cat - vecdp.srec > vecdp-all.srec
"$SIM" -n 2000000 --entry "0x$start" vecdp-all.srec > vecdp.run 2>&1
echo $? > vecdp.run.rc
sed -i "s/ reached at PC=$stop\$/ reached, in _exit's loop/" vecdp.run
rm -f vecdp.srec vecdp-map.srec vecdp.map vecdp-all.srec
# the list, text and score functions (veclist.c): what each BIOS routine
# gets, and DP, with the program's ($C8) back after each
run veclist.bcc "$BCC" -Mv -o veclist.srec -X-Svecsrec.ld veclist.c
"$BCC" -Mv -o veclist-map.srec -X-Svecsrec.ld -X-M veclist.c > veclist.map 2>&1
start=$(grep -a ' crt0 *start ' veclist.map | awk '{ print substr($4, 5) }')
stop=$(grep -a ' __exit ' veclist.map | awk '{ print $4 }')
stop=$(printf '%04X' $((0x$stop + 2)))
awk 'substr($0, 1, 2) == "S1" && substr($0, 5, 4) >= "F000"' vecbios.srec |
	cat - veclist.srec > veclist-all.srec
"$SIM" -n 2000000 --entry "0x$start" veclist-all.srec > veclist.run 2>&1
echo $? > veclist.run.rc
sed -i "s/ reached at PC=$stop\$/ reached, in _exit's loop/" veclist.run
rm -f veclist.srec veclist-map.srec veclist.map veclist-all.srec
rm -f vecsrec.ld vectest.srec vectest-map.srec vectest.map vecbios.o \
	vecbios.out vecbios.srec vectest-all.srec vectest.bin
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
# __direct variables in a Color BASIC program: dpcb.c prints, reads a
# line, reads the joysticks and writes and reads a file, with DP the
# variables' page between the calls into the ROM (cbrom.s and cbdisk.s
# print # if one is called with another)
run dpcb.bcc "$BCC" -Me -o dpcb.out -X-T0x3000 loader.s dpcb.c
"$OC" -O srec dpcb.out dpcb.srec
entry=$("$OD" -n dpcb.out | awk '$3 == "loader" { print $1 }')
grep -hv '^S[059]' cbrom.srec cbdisk.srec | cat - dpcb.srec > dpcb-rom.srec
"$SIM" -n 100000000 --entry "0x$entry" dpcb-rom.srec < dpcb.in \
	> dpcb.run 2>&1
echo $? > dpcb.run.rc
rm -f dpcb.srec dpcb-rom.srec
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
# __direct variables in a FLEX command: flexdp.c checks that FLEX's calls
# give DP (the variables' page) back
run flexdp.bcc "$BCC" -Mf -o flexdp.out -X-T0x1000 flexdp.c
"$OC" -O flex flexdp.out FLEXDP.CMD
"$SIM" -n 50000000 --flex FLEXDP.CMD < flexdp.in > flexdp.run 2>&1
echo $? > flexdp.run.rc
rm -f FLEXDP.CMD
# and FLEX's files: flexfile.c under sim6809, whose FMS keeps each file's
# sectors' data in a host file (here); the four files it leaves (TEXT.TXT,
# BIN.DAT, DRV.TXT, LOWER.TXT) are results too, and must be what FLEX
# itself writes (make check-flex)
run flexfile.bcc "$BCC" -Mf -o flexfile.out -X-T0x1000 flexfile.c
"$OC" -O flex flexfile.out FLEXFILE.CMD
"$SIM" -n 100000000 --flex FLEXFILE.CMD < /dev/null > flexfile.run 2>&1
echo $? > flexfile.run.rc
rm -f FLEXFILE.CMD

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
for f in hello echo pftest siotest chartest sadd sftest fltcc fpio mtest inttest protoarg gltest \
	 dptest; do
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
# and as09 takes a source file name of any length (it stopped at 64
# characters): simcrt0.s in a directory with a name of 240 characters
# must give the object it does here
"$AS" -o simcrt0-path.o simcrt0.s > /dev/null 2>&1
long=$(printf 'd%.0s' $(seq 1 240))
mkdir $long
cp simcrt0.s $long/
if "$AS" -o $long/simcrt0.o $long/simcrt0.s > /dev/null 2>&1 &&
   cmp -s simcrt0-path.o $long/simcrt0.o; then
	echo "ok   as09 assembles a file of a 250-character name"
else
	echo "DIFF as09 with a file of a 250-character name"
fi >> pathlen.result
rm -rf $long
rm -f simcrt0-path.o

run notarget.bcc "$BCC" -Mu -o notarget.out hello.c
rm -f notarget.out
# cc1's -c- and -f- (callee saves, the first argument on the stack) are
# errors: libc and its helpers are built with the 6809's conventions
run ccsave.bcc "$BCC" -C-c- -c -o ccsave.o hello.c
run ccarg.bcc "$BCC" -C-f- -c -o ccarg.o hello.c
rm -f ccsave.o ccarg.o

# the copied sources aren't results
for f in "$tests"/src/*; do
	rm -f "$(basename "$f")"
done
for f in "$tests"/scripts/*; do
	rm -f "$(basename "$f")"
done
for f in segs helper usesym page romcrt romvec romstart vectors noload \
	 mainent; do
	rm -f $f.o
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
