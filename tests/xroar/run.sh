#!/bin/sh
#
# Tests of the Color BASIC target (bcc09 -Me) on real Color BASIC and
# Dragon ROMs, in the XRoar emulator: xcb.c is built by bcc09 alone, put
# on a cassette by objcopy09, loaded with CLOADM and run with EXEC; XRoar
# types its input, and when it calls _exit a trap takes a snapshot, from
# which xrscreen.py shows the text screen and xrcpu.py the registers.
# Each machine's screen must be the same as ./expected, and the exit
# status (X) 42.  Then coco.h, the example game doc/worm.c, a ROM
# cartridge (-Mr), and Disk BASIC's files (see below; needs toolshed's
# decb too).
#
# Optional (make check-xroar): it needs xroar, python3 and the machines'
# ROMs (in ~/.xroar/roms, say); a machine whose ROM isn't there or
# doesn't check is skipped.  XRoar always runs without a window (-ui
# null), and is stopped after 30 seconds if it hasn't finished.

top=$(cd "$(dirname "$0")/../.." && pwd)
dir=$top/tests/xroar
machines="coco cocous dragon32 dragon64"

for prog in xroar python3; do
	if ! command -v $prog > /dev/null 2>&1; then
		echo "xroar tests skipped: no $prog"
		exit 0
	fi
done

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
cd "$work" || exit 1

# a prefix of links to this build, for the compiler driver
mkdir -p prefix/bin prefix/libexec/bcc09 prefix/share/bcc09
ln -s "$top/as/as09" "$top/ld/ld09" prefix/bin/
ln -s "$top/cpp/cpp" "$top/bcc/cc1" "$top/copt/copt" "$top/copt/rules.6809" \
	"$top/unproto/unproto" prefix/libexec/bcc09/
ln -s "$top/libc/libc.a" "$top/libc/include" "$top/libc/crt0.o" \
	"$top/libc/libcb.a" "$top/libc/crtrom.o" "$top/libc/librom.a" \
	"$top/libc/rom/rom.ld" prefix/share/bcc09/

BCC_PREFIX=$work/prefix "$top/bcc/bcc09" -Me -o xcb -X-T0x3000 "$dir/xcb.c" ||
	exit 1
"$top/ld/objcopy09" -O cas -n XCB xcb xcb.cas || exit 1
"$top/ld/objcopy09" -O decb xcb xcb.bin || exit 1
exit_pc=$("$top/ld/objdump09" -n xcb | awk '$3 == "__exit" { print $1 }')

failed=0
for m in $machines; do
	rm -f snap
	timeout 60 xroar -ui null -ao null -machine $m -no-ratelimit \
		-load-tape xcb.cas \
		-type "$(printf 'CLOADM:EXEC\rABX\bC\r123\r')" \
		-trap pc=0x$exit_pc -trap-snap snap -trap-timeout 0 \
		-timeout 30 > $m.log 2>&1
	if grep -qiE "CRC32 INVALID|not found|no rom" $m.log; then
		echo "skip $m (its ROM isn't there or doesn't check)"
		continue
	fi
	if [ ! -f snap ]; then
		echo "FAIL $m: it didn't reach _exit"
		failed=$((failed + 1))
		continue
	fi
	# (CLOADM's F, inverse or not as the loaded blocks are odd or even)
	python3 "$dir/xrscreen.py" snap xcb.bin 0x3000 | grep -v '^$' |
		sed '1s/^f /F /' > $m.screen
	status=$(python3 "$dir/xrcpu.py" snap | awk '$1 == "0c:" { print $2 }')
	if cmp -s "$dir/expected" $m.screen && [ "$status" = "002a" ]; then
		echo "ok   $m"
		continue
	fi
	failed=$((failed + 1))
	if [ "$status" != "002a" ]; then
		echo "FAIL $m: exit status $status, not 002a"
	fi
	if ! cmp -s "$dir/expected" $m.screen; then
		echo "FAIL $m: the screen differs:"
		diff "$dir/expected" $m.screen
	fi
done

# coco.h (cls, locate, inkey, joystk): xcoco.c, built and loaded as
# xcb.c is; it waits for a key, which XRoar types after the EXEC.  The
# screen must be the same as ./expected-coco, and the status 42.
BCC_PREFIX=$work/prefix "$top/bcc/bcc09" -Me -o xcoco -X-T0x3000 \
	"$dir/xcoco.c" || exit 1
"$top/ld/objcopy09" -O cas -n XCOCO xcoco xcoco.cas || exit 1
"$top/ld/objcopy09" -O decb xcoco xcoco.bin || exit 1
cexit_pc=$("$top/ld/objdump09" -n xcoco | awk '$3 == "__exit" { print $1 }')
for m in $machines; do
	rm -f snap
	timeout 60 xroar -ui null -ao null -machine $m -no-ratelimit \
		-load-tape xcoco.cas \
		-type "$(printf 'CLOADM:EXEC\rQ')" \
		-trap pc=0x$cexit_pc -trap-snap snap -trap-timeout 0 \
		-timeout 30 > $m-coco.log 2>&1
	if grep -qiE "CRC32 INVALID|not found|no rom" $m-coco.log; then
		echo "skip $m coco.h (its ROM isn't there or doesn't check)"
		continue
	fi
	if [ ! -f snap ]; then
		echo "FAIL $m coco.h: it didn't reach _exit"
		failed=$((failed + 1))
		continue
	fi
	python3 "$dir/xrscreen.py" snap xcoco.bin 0x3000 > $m-coco.screen
	status=$(python3 "$dir/xrcpu.py" snap | awk '$1 == "0c:" { print $2 }')
	if cmp -s "$dir/expected-coco" $m-coco.screen && [ "$status" = "002a" ]; then
		echo "ok   $m coco.h"
		continue
	fi
	failed=$((failed + 1))
	if [ "$status" != "002a" ]; then
		echo "FAIL $m coco.h: exit status $status, not 002a"
	fi
	if ! cmp -s "$dir/expected-coco" $m-coco.screen; then
		echo "FAIL $m coco.h: the screen differs:"
		diff "$dir/expected-coco" $m-coco.screen
	fi
done

# doc/worm.c, the example game, played: XRoar types one key for each of
# its moves (it reads one a move, as INKEY$), and the game is the same
# every time (rand() seeded by the wait for the first key, which comes at
# once): '.' goes on, newline (10) is down, backspace (8) left; it eats
# two pieces of food, hits the wall, plays again, BREAKs that game and
# stops.  The board when it first asks to play again (its 47th key) and
# the screen at _exit must be the same as ./expected-worm, and the
# status 0.
BCC_PREFIX=$work/prefix "$top/bcc/bcc09" -Me -O -o worm -X-T0x3000 \
	"$top/doc/worm.c" || exit 1
"$top/ld/objcopy09" -O cas -n WORM worm worm.cas || exit 1
"$top/ld/objcopy09" -O decb worm worm.bin || exit 1
wexit_pc=$("$top/ld/objdump09" -n worm | awk '$3 == "__exit" { print $1 }')
winkey_pc=$("$top/ld/objdump09" -n worm | awk '$3 == "_inkey" { print $1 }')
moves=$(printf ' ............\n....\b..............................\r\003\003')
for m in $machines; do
	rm -f snap snap2
	timeout 60 xroar -ui null -ao null -machine $m -no-ratelimit \
		-load-tape worm.cas -type "$(printf 'CLOADM:EXEC\r')$moves" \
		-trap pc=0x$winkey_pc -trap-range 47-47 -trap-snap snap \
		-trap-timeout 0 -timeout 30 > $m-worm.log 2>&1
	if grep -qiE "CRC32 INVALID|not found|no rom" $m-worm.log; then
		echo "skip $m worm (its ROM isn't there or doesn't check)"
		continue
	fi
	timeout 60 xroar -ui null -ao null -machine $m -no-ratelimit \
		-load-tape worm.cas -type "$(printf 'CLOADM:EXEC\r')$moves" \
		-trap pc=0x$wexit_pc -trap-snap snap2 -trap-timeout 0 \
		-timeout 30 >> $m-worm.log 2>&1
	if [ ! -f snap ] || [ ! -f snap2 ]; then
		echo "FAIL $m worm: it didn't reach game over and _exit"
		failed=$((failed + 1))
		continue
	fi
	{ python3 "$dir/xrscreen.py" -g snap worm.bin 0x3000
	  python3 "$dir/xrscreen.py" snap2 worm.bin 0x3000 | grep -v '^$'
	} > $m-worm.screen
	status=$(python3 "$dir/xrcpu.py" snap2 | awk '$1 == "0c:" { print $2 }')
	if cmp -s "$dir/expected-worm" $m-worm.screen && [ "$status" = "0000" ]; then
		echo "ok   $m worm"
		continue
	fi
	failed=$((failed + 1))
	if [ "$status" != "0000" ]; then
		echo "FAIL $m worm: exit status $status, not 0000"
	fi
	if ! cmp -s "$dir/expected-worm" $m-worm.screen; then
		echo "FAIL $m worm: the screen differs:"
		diff "$dir/expected-worm" $m-worm.screen
	fi
done

# a ROM cartridge (bcc09 -Mr): xrom.c, built as rom.ld lays it out (the
# image to plug in at $C000), started by BASIC (-cart-autorun); its
# initialized data is copied to RAM at $0600, where xrscreen.py finds it
# by its first string (given as a DECB file loaded there).  The screen
# must be the same as ./expected-rom, and the status 42.  (Not on the
# CoCo 3, which starts a cartridge before BASIC is ready for its I/O.)
BCC_PREFIX=$work/prefix "$top/bcc/bcc09" -Mr -o xrom.rom -X-M "$dir/xrom.c" \
	> xrom.map || exit 1
rexit_pc=$(awk '$2 == "__exit" { print substr($4, 5) }' xrom.map)
python3 -c 'import sys
m = b"XROM DATA AT 0600"
sys.stdout.buffer.write(bytes([0, 0, len(m), 6, 0]) + m)' > xrom-data.bin
for m in $machines; do
	rm -f snap
	timeout 60 xroar -ui null -ao null -machine $m -no-ratelimit \
		-cart-rom xrom.rom -cart-autorun \
		-type "$(printf 'ABX\bC\r')" \
		-trap pc=0x$rexit_pc -trap-snap snap -trap-timeout 0 \
		-timeout 30 > $m-rom.log 2>&1
	if grep -qiE "CRC32 INVALID|not found|no rom" $m-rom.log; then
		echo "skip $m rom (its ROM isn't there or doesn't check)"
		continue
	fi
	if [ ! -f snap ]; then
		echo "FAIL $m rom: it didn't reach _exit"
		failed=$((failed + 1))
		continue
	fi
	python3 "$dir/xrscreen.py" snap xrom-data.bin 0x0600 | grep -v '^$' \
		> $m-rom.screen
	status=$(python3 "$dir/xrcpu.py" snap | awk '$1 == "0c:" { print $2 }')
	if cmp -s "$dir/expected-rom" $m-rom.screen && [ "$status" = "002a" ]; then
		echo "ok   $m rom"
		continue
	fi
	failed=$((failed + 1))
	if [ "$status" != "002a" ]; then
		echo "FAIL $m rom: exit status $status, not 002a"
	fi
	if ! cmp -s "$dir/expected-rom" $m-rom.screen; then
		echo "FAIL $m rom: the screen differs:"
		diff "$dir/expected-rom" $m-rom.screen
	fi
done

# Disk BASIC's files: xdisk.c, built the same way, run with a disk in
# drive 0 that toolshed's decb made and put IN.DAT on; then BASIC reads
# OUT.TXT, which xdisk wrote, and writes BAS.DAT; a read of $FF6A (no
# device) ends the run.  The screen must be the same as ./expected-disk,
# and xrdisk.py checks the disk: its files, and that every granule in
# use is in one file.  On the CoCo with Disk BASIC 1.0, the CoCo 2 with
# 1.1 and, if $COCO3_ROM is there, the CoCo 3; there a trap at _exit
# ends the run (exit status 0: XRoar doesn't see the PEEK there), with
# no BAS.DAT.
if command -v decb > /dev/null 2>&1; then
	BCC_PREFIX=$work/prefix "$top/bcc/bcc09" -Me -o xdisk -X-T0x3000 \
		"$dir/xdisk.c" || exit 1
	"$top/ld/objcopy09" -O cas -n XDISK xdisk xdisk.cas || exit 1
	"$top/ld/objcopy09" -O decb xdisk xdisk.bin || exit 1
	dexit_pc=$("$top/ld/objdump09" -n xdisk | awk '$3 == "__exit" { print $1 }')
	printf 'HELLO, DISK\r' > in.dat
	rom3=${COCO3_ROM:-/usr/share/mame/roms/coco3.rom}
	for c in coco:disk10 cocous:disk11 coco3:disk11; do
		m=${c%%:*}
		extra=
		if [ $m = coco3 ]; then
			[ -r "$rom3" ] || { echo "skip coco3 disk (no $rom3)"; continue; }
			extra="-extbas $rom3"
		fi
		rm -f snap disk.dsk
		decb dskini disk.dsk > /dev/null &&
			decb copy -1 -a in.dat disk.dsk,IN.DAT > /dev/null || exit 1
		if [ $m = coco3 ]; then
			typed='CLOADM:EXEC\r'
			trap="pc=0x$dexit_pc"
		else
			typed='CLOADM:EXEC\r10 OPEN"I",#1,"OUT.TXT":LINE INPUT#1,A$:CLOSE#1:PRINT A$\r20 OPEN"O",#1,"BAS.DAT":PRINT#1,"FROM BASIC":CLOSE#1\rRUN\rX=PEEK(\&HFF6A)\r'
			trap=read=0xFF6A
		fi
		# shellcheck disable=SC2086
		timeout 90 xroar -ui null -ao null -machine $m $extra \
			-cart rsdos -cart-rom ${c#*:} -no-ratelimit \
			-load-fd0 disk.dsk -load-tape xdisk.cas \
			-type "$(printf "$typed")" \
			-trap $trap -trap-snap snap -trap-timeout 1 \
			-timeout 60 > $m-disk.log 2>&1
		if grep -qiE "CRC32 INVALID|not found|no rom" $m-disk.log; then
			echo "skip $m disk (its ROM isn't there or doesn't check)"
			continue
		fi
		if [ ! -f snap ]; then
			echo "FAIL $m disk: it didn't finish"
			failed=$((failed + 1))
			continue
		fi
		if [ $m = coco3 ]; then
			status=$(python3 "$dir/xrcpu.py" snap |
				awk '$1 == "0c:" { print $2 }')
			if [ "$status" != 0000 ]; then
				echo "FAIL $m disk: exit status $status"
				failed=$((failed + 1))
			elif ! python3 "$dir/xrdisk.py" disk.dsk nobasic \
				> $m-disk.check; then
				echo "FAIL $m disk: the disk isn't right:"
				cat $m-disk.check
				failed=$((failed + 1))
			else
				echo "ok   $m disk (${c#*:}; no BASIC after)"
			fi
			continue
		fi
		python3 "$dir/xrscreen.py" snap xdisk.bin 0x3000 |
			grep -v '^$' | sed '1s/^f /F /' > $m-disk.screen
		if ! cmp -s "$dir/expected-disk" $m-disk.screen; then
			echo "FAIL $m disk: the screen differs:"
			diff "$dir/expected-disk" $m-disk.screen
			failed=$((failed + 1))
		elif ! python3 "$dir/xrdisk.py" disk.dsk > $m-disk.check; then
			echo "FAIL $m disk: the disk isn't right:"
			cat $m-disk.check
			failed=$((failed + 1))
		else
			echo "ok   $m disk (${c#*:})"
		fi
	done
else
	echo "disk tests skipped: no decb (toolshed)"
fi

if [ $failed != 0 ]; then
	echo "$failed test(s) failed"
	exit 1
fi
