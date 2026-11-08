#!/bin/sh
#
# Tests of the Color BASIC target (bcc09 -Me) on real Color BASIC and
# Dragon ROMs, in the XRoar emulator: xcb.c is built by bcc09 alone, put
# on a cassette by objcopy09, loaded with CLOADM and run with EXEC; XRoar
# types its input, and when it calls _exit a trap takes a snapshot, from
# which xrscreen.py shows the text screen and xrcpu.py the registers.
# Each machine's screen must be the same as ./expected, and the exit
# status (X) 42.
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
mkdir -p prefix/bin prefix/libexec/bcc09 prefix/lib/bcc09
ln -s "$top/as/as09" "$top/ld/ld09" prefix/bin/
ln -s "$top/cpp/cpp" "$top/bcc/cc1" "$top/copt/copt" "$top/copt/rules.6809" \
	"$top/unproto/unproto" prefix/libexec/bcc09/
ln -s "$top/libc/libc.a" "$top/libc/include" "$top/libc/crt0.o" \
	"$top/libc/libcb.a" prefix/lib/bcc09/

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
	python3 "$dir/xrscreen.py" snap xcb.bin 0x3000 | grep -v '^$' > $m.screen
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

if [ $failed != 0 ]; then
	echo "$failed machine(s) failed"
	exit 1
fi
