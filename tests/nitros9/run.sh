#!/bin/sh
#
# Tests of the OS-9 target (bcc09 -Mo) on real NitrOS-9 Level 2, on an
# emulated CoCo 3 in XRoar: the programs that make check runs as OS-9
# modules under sim6809 --os9 are built by bcc09, made into modules by
# objcopy09 and put on a blank disk in drive 1 (/d1), and the startup
# script on a copy of a bootable NitrOS-9 disk in drive 0 runs each,
# with its output redirected to a file on /d1, through trun.c, which
# writes its exit status (from F$Wait: the shell doesn't show it) to
# another; then tdone.c reads $FF6A, an unused address in the I/O page,
# which XRoar traps on to stop.  Each output and status, copied off the
# disk, must be the same as the program's reference output and status
# (tests/ref/NAME.run and NAME.run.rc), which sim6809 gave.
#
# Optional (make check-nitros9): it needs xroar, toolshed's os9 tool, a
# NitrOS-9 Level 2 disk image ($NITROS9_DISK, ~/coco/nitros9.os9 by
# default) and the CoCo 3's ROM ($COCO3_ROM, by default
# /usr/share/mame/roms/coco3.rom).  XRoar runs without a window (-ui
# null), and is stopped after 15 minutes if it hasn't finished.
# NITROS9_KEEP=1 keeps the files (the disk, the outputs), and
# NITROS9_PROGS="a b" runs only those programs.  ttime.c checks time()
# there too (sim6809 has no F$Time).

top=$(cd "$(dirname "$0")/../.." && pwd)
dir=$top/tests/nitros9
disk=${NITROS9_DISK:-$HOME/coco/nitros9.os9}
rom=${COCO3_ROM:-/usr/share/mame/roms/coco3.rom}
# (os9io is given the parameters "one two"; the module names are the
# programs', none of them a NitrOS-9 command)
progs=${NITROS9_PROGS:-os9io os9dir os9path hello pftest chartest sadd fltcc fpio inttest protoarg dptest}

for prog in xroar os9; do
	if ! command -v $prog > /dev/null 2>&1; then
		echo "nitros9 tests skipped: no $prog"
		exit 0
	fi
done
for f in "$disk" "$rom"; do
	if [ ! -r "$f" ]; then
		echo "nitros9 tests skipped: no $f (set NITROS9_DISK, COCO3_ROM)"
		exit 0
	fi
done

work=$(mktemp -d)
if [ -n "$NITROS9_KEEP" ]; then
	echo "nitros9 tests: the files are in $work"
else
	trap 'rm -rf "$work"' EXIT
fi
cd "$work" || exit 1

# a prefix of links to this build, for the compiler driver
mkdir -p prefix/bin prefix/libexec/bcc09 prefix/share/bcc09
ln -s "$top/as/as09" "$top/ld/ld09" prefix/bin/
ln -s "$top/cpp/cpp" "$top/bcc/cc1" "$top/copt/copt" "$top/copt/rules.6809" \
	"$top/unproto/unproto" prefix/libexec/bcc09/
ln -s "$top/libc/include" "$top/libc/crtos9.o" "$top/libc/libos9.a" \
	prefix/share/bcc09/

# the boot disk: images are often cut short after the last sector in
# use, and XRoar would then see fewer cylinders than the file system
# has, so it is padded to DD.TOT (LSN 0's first 3 bytes) sectors
boot=nitros9.os9
cp "$disk" $boot
size=$(od -An -tu1 -N3 $boot | awk '{ print ($1 * 65536 + $2 * 256 + $3) * 256 }')
[ "$size" -gt "$(wc -c < $boot)" ] && truncate -s "$size" $boot
# the disk in drive 1, made as NitrOS-9's D1 has it (40 tracks, double
# sided, 48 tpi: 360K), since a boot disk may have no room for them
img=work.os9
os9 format -q -e -4 -ds -t40 -nbcc09 $img > /dev/null &&
	os9 makdir $img,CMDS > /dev/null || exit 1
: > empty
os9 copy -r empty $img,empty.in > /dev/null || exit 1

# the modules, and the startup script (-x: go on after an error)
printf -- '-x\rchd /d1\rchx /d1/CMDS\r' > startup
for f in $progs ttime tdone trun; do
	src=$top/tests/src/$f.c
	case $f in ttime|tdone|trun) src=$dir/$f.c ;; esac
	if ! BCC_PREFIX=$work/prefix "$top/bcc/bcc09" -Mo -o $f.out "$src" ||
	   ! "$top/ld/objcopy09" -O os9 -n $f $f.out $f.mod ||
	   ! os9 copy -r $f.mod $img,CMDS/$f > /dev/null ||
	   ! os9 attr -e -pe $img,CMDS/$f > /dev/null; then
		echo "FAIL $f: can't build it or put it on the disk"
		exit 1
	fi
	case $f in tdone|trun) continue ;; esac
	params=
	[ $f = ttime ] && { printf 'trun ttime <empty.in >ttime.run\r' >> startup; continue; }
	[ $f = os9io ] && params=" one two"
	printf 'trun %s%s <empty.in >%s.run\r' $f "$params" $f >> startup
done
printf 'echo done >done.txt\rtdone\r' >> startup
os9 copy -r -l startup $boot,startup > /dev/null || exit 1

# DOS boots NitrOS-9; -timeout (emulated seconds) only guards against a
# hang, as the trap on tdone's read ends the run
timeout 900 xroar -q -machine coco3 -extbas "$rom" -ui null -ao null \
	-no-ratelimit -load-fd0 $boot -load-fd1 $img -type 'DOS\r' \
	-trap read=0xFF6A \
	-trap-timeout 1 -timeout 3000 > xroar.log 2>&1
if ! os9 dir $img 2>/dev/null | grep -qw done.txt; then
	echo "FAIL the startup script didn't finish"
	exit 1
fi

failed=0
for f in $progs; do
	os9 copy $img,$f.run $f.run > /dev/null 2>&1 || : > $f.run
	os9 copy $img,$f.rc $f.rc > /dev/null 2>&1 || : > $f.rc
	if ! cmp -s $f.run "$top/tests/ref/$f.run"; then
		echo "FAIL $f: its output isn't tests/ref/$f.run"
		diff "$top/tests/ref/$f.run" $f.run | head -10
		failed=$((failed + 1))
	elif ! cmp -s $f.rc "$top/tests/ref/$f.run.rc"; then
		echo "FAIL $f: exit status $(cat $f.rc), not" \
			"$(cat "$top/tests/ref/$f.run.rc")"
		failed=$((failed + 1))
	else
		echo "ok   $f (exit status $(cat $f.rc))"
	fi
done
# time(): F$Time, which sim6809 doesn't have (ttime.c), whatever the date
os9 copy $img,ttime.run ttime.run > /dev/null 2>&1 || : > ttime.run
if cmp -s ttime.run "$dir/expected-time"; then
	echo "ok   ttime (time() is OS-9's clock)"
else
	echo "FAIL ttime: $(tr '\r' '\n' < ttime.run)"
	failed=$((failed + 1))
fi
exit $failed
