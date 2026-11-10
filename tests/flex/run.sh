#!/bin/sh
#
# Tests of the FLEX target (bcc09 -Mf) on real FLEX: Compusense FLEX for
# the Dragon 64, booted from DragonDOS in XRoar.  xflex.c is built by
# bcc09 and made a .CMD file by objcopy09, and put on a copy of a FLEX
# disk ($FLEX_DISK, ~/coco/flex/FLEX_1.3.2.VDK by default) with
# flexdisk.py; its STARTUP file EXECs a command file that runs it as
# "P,XFLEX one,two three" (P prints its output too, and XRoar writes the
# printer's to a file), then "P,FLEXFILE" (tests/src/flexfile.c, FLEX's
# files), then DONE (done.s, at $C600, where XRoar traps and quits).  The
# printer's output must be the same as ./expected, then what flexfile
# prints under sim6809 --flex; and the files flexfile leaves, read off
# the disk by flexdisk.py, must be the same as the ones it leaves under
# sim6809 (whose FMS keeps a file's sectors' data in a host file).  The
# boot image is patched not to ask for the date: XRoar's -type only
# reaches BASIC, not FLEX (as plm09's dragonflex tests do, whose
# flexdisk.py this is).
#
# Optional (make check-flex): it needs xroar, python3, the Dragon 64's
# and DragonDOS's ROMs, and the disk image.  XRoar runs without a window
# (-ui null), and is stopped after 15 emulated minutes, or 5 real ones,
# if it hasn't finished.
# FLEX_KEEP=1 keeps the files.

top=$(cd "$(dirname "$0")/../.." && pwd)
dir=$top/tests/flex
disk=${FLEX_DISK:-$HOME/coco/flex/FLEX_1.3.2.VDK}

for prog in xroar python3; do
	if ! command -v $prog > /dev/null 2>&1; then
		echo "flex tests skipped: no $prog"
		exit 0
	fi
done
if [ ! -r "$disk" ]; then
	echo "flex tests skipped: no $disk (set FLEX_DISK)"
	exit 0
fi

work=$(mktemp -d)
if [ -n "$FLEX_KEEP" ]; then
	echo "flex tests: the files are in $work"
else
	trap 'rm -rf "$work"' EXIT
fi
cd "$work" || exit 1

# a prefix of links to this build, for the compiler driver
mkdir -p prefix/bin prefix/libexec/bcc09 prefix/share/bcc09
ln -s "$top/as/as09" "$top/ld/ld09" prefix/bin/
ln -s "$top/cpp/cpp" "$top/bcc/cc1" "$top/copt/copt" "$top/copt/rules.6809" \
	"$top/unproto/unproto" prefix/libexec/bcc09/
ln -s "$top/libc/libc.a" "$top/libc/include" "$top/libc/crtflex.o" \
	"$top/libc/libflex.a" prefix/share/bcc09/

BCC_PREFIX=$work/prefix "$top/bcc/bcc09" -Mf -o xflex -X-T0x1000 \
	"$dir/xflex.c" || exit 1
"$top/ld/objcopy09" -O flex xflex XFLEX.CMD || exit 1
BCC_PREFIX=$work/prefix "$top/bcc/bcc09" -Mf -o flexfile -X-T0x1000 \
	"$top/tests/src/flexfile.c" || exit 1
"$top/ld/objcopy09" -O flex flexfile FLEXFILE.CMD || exit 1
# flexfile under sim6809, in sim/: its output, and its files
mkdir sim
(cd sim && "${SIM6809:-sim6809}" -n 100000000 --flex ../FLEXFILE.CMD \
	< /dev/null > ../flexfile.sim 2>&1)
files="TEXT.TXT BIN.DAT DRV.TXT LOWER.TXT"
"$top/as/as09" -o done.o "$dir/done.s" &&
	"$top/ld/ld09" -T0xc600 -o done done.o &&
	"$top/ld/objcopy09" -O flex done DONE.CMD || exit 1

fd() {
	python3 -I "$dir/flexdisk.py" flex.vdk "$@"
}
cp "$disk" flex.vdk
# FLEX's cold start calls its date prompt at $CA02 (JSR $CAAC): skip it
if ! fd patch @1/1 CA02 BDCAAC 121212; then
	echo "FAIL this FLEX boot image can't be patched (Compusense FLEX 1.2/1.3)"
	exit 1
fi
printf 'P,XFLEX one,two three\nP,FLEXFILE\nDONE\n' > tests.txt
printf 'EXEC TESTS\n' > startup.txt
if ! fd put XFLEX.CMD XFLEX.CMD || ! fd put FLEXFILE.CMD FLEXFILE.CMD ||
   ! fd put DONE.CMD DONE.CMD ||
   ! fd puttext tests.txt TESTS.TXT || ! fd puttext startup.txt STARTUP.TXT; then
	echo "FAIL can't put the files on the disk"
	exit 1
fi

# RETURN dismisses the Dragon 64's PRESS ANY KEY; -timeout (emulated
# seconds) only guards against a hang: the disk runs at a real drive's
# speed, and each file opened is searched for in FLEX's long directory,
# so flexfile takes a few minutes (DONE's trap snapshot shows it ended)
timeout 300 xroar -q -machine dragon64 -ui null -ao null -no-ratelimit \
	-load-fd0 flex.vdk -type '\rBOOT\r' -lp-file printer.txt \
	-trap pc=0xC600 -trap-snap done.snap -trap-timeout 1 -timeout 900 \
	> xroar.log 2>&1
if [ ! -f done.snap ]; then
	echo "FAIL the command file didn't finish (no DONE)"
	exit 1
fi
# the printer's output: NULs (TTYSET's padding) and LFs dropped, CRs made
# new lines
if [ ! -f printer.txt ]; then
	echo "FAIL nothing was printed"
	exit 1
fi
failed=0
tr -d '\000\n' < printer.txt | tr '\r' '\n' > printed.out
cat "$dir/expected" flexfile.sim > expected.out
if cmp -s expected.out printed.out; then
	echo "ok   xflex, and flexfile prints what it does under sim6809"
else
	echo "FAIL the output differs:"
	diff expected.out printed.out
	failed=1
fi
for f in $files; do
	if ! fd get $f $f > /dev/null 2>&1; then
		echo "FAIL flexfile didn't leave $f"
		failed=1
	elif ! cmp -s sim/$f $f; then
		echo "FAIL $f isn't what flexfile leaves under sim6809"
		cmp sim/$f $f
		failed=1
	else
		echo "ok   $f is what flexfile leaves under sim6809"
	fi
done
exit $failed
