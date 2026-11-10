#!/bin/sh
#
# Tests of the Vectrex target (bcc09 -Mv) on the Vectrex's BIOS, in
# MAME: xvec.c is built by bcc09 alone into a cartridge's image, which
# MAME's vectrex runs after the BIOS's title screen (with the default
# header); run.lua stops it when it reaches _exit's loop, and prints its
# exit status and its results[], read from RAM, which must be the same
# as ./expected.
#
# Optional (make check-vectrex): it needs mame and the Vectrex's BIOS:
# $VECTREX_ROM (an 8K image, used as exec_rom.bin; by default
# ~/vectrex/bnz17/SYSTEM.IMG), or MAME's own vectrex ROM set.  MAME runs
# without a window or sound, keeps the files it saves in the scratch
# directory, and is stopped after 3000 frames if the program hasn't
# finished.

top=$(cd "$(dirname "$0")/../.." && pwd)
dir=$top/tests/vectrex

if ! command -v mame > /dev/null 2>&1; then
	echo "vectrex tests skipped: no mame"
	exit 0
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
cd "$work" || exit 1

# the BIOS: $VECTREX_ROM, or MAME's
rom=${VECTREX_ROM:-$HOME/vectrex/bnz17/SYSTEM.IMG}
if [ -f "$rom" ]; then
	mkdir -p roms/vectrex
	cp "$rom" roms/vectrex/exec_rom.bin
	rompath="-rompath roms"
elif mame -verifyroms vectrex > /dev/null 2>&1; then
	rompath=
else
	echo "vectrex tests skipped: no BIOS (set VECTREX_ROM)"
	exit 0
fi

# a prefix of links to this build, for the compiler driver
mkdir -p prefix/bin prefix/libexec/bcc09 prefix/share/bcc09
ln -s "$top/as/as09" "$top/ld/ld09" prefix/bin/
ln -s "$top/cpp/cpp" "$top/bcc/cc1" "$top/copt/copt" "$top/copt/rules.6809" \
	"$top/unproto/unproto" prefix/libexec/bcc09/
ln -s "$top/libc/libc.a" "$top/libc/include" "$top/libc/crtvec.o" \
	"$top/libc/libvec.a" "$top/libc/vec/vectrex.ld" prefix/share/bcc09/

BCC_PREFIX=$work/prefix "$top/bcc/bcc09" -Mv -O -o xvec.bin -X-M \
	"$dir/xvec.c" > xvec.map || exit 1
stop=$(grep -a ' __exit ' xvec.map | awk '{ print $4 }')
stop=$(printf '%04X' $((0x$stop + 2)))
results=$(grep -a ' _results ' xvec.map | awk '{ print substr($4, 5) }')

# (MAME's own files, which it saves on exit, go here, not in the user's
# MAME directories)
STOP=$stop RESULTS=$results timeout 300 mame vectrex $rompath \
	-cart xvec.bin -video none -sound none -nothrottle -skip_gameinfo \
	-cfg_directory cfg -nvram_directory nvram -diff_directory diff \
	-snapshot_directory snap -state_directory sta \
	-autoboot_script "$dir/run.lua" > mame.log 2>&1
grep -E '^(stopped|not stopped|results)' mame.log > xvec.result
if cmp -s "$dir/expected" xvec.result; then
	echo "ok   vectrex"
	exit 0
fi
echo "FAIL vectrex:"
diff "$dir/expected" xvec.result
tail -5 mame.log
exit 1
