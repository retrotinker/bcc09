#!/bin/sh
#
# Cycles that floating point takes in bcc09's libc, for timing changes to
# the helpers (libc/bcc/fp*.s); not one of the regression tests.
#
# Each line is the cycles one statement takes on average, over 64 pairs
# of random operands (normal numbers, from 2^-20 to 2^21), less a loop
# that only copies one: so the compiler's code around the helper call is
# counted, as it is in a program.  sim6809 --cycles counts them.  Build
# the tree first (make).
#
# usage: fpbench.sh

top=$(cd "$(dirname "$0")/.." && pwd)
SIM=${SIM6809:-sim6809}
if ! command -v "$SIM" > /dev/null 2>&1; then
	echo "fpbench.sh: no $SIM (see tests/run.sh)" >&2
	exit 2
fi

work=$(mktemp -d) || exit 1
trap 'rm -rf "$work"' EXIT
prefix=$work/prefix
mkdir -p "$prefix/bin" "$prefix/libexec/bcc09" "$prefix/share/bcc09"
ln -s "$top/as/as09" "$top/ld/ld09" "$top/bcc/bcc09" "$top/ld/objcopy09" \
	"$prefix/bin/"
ln -s "$top/cpp/cpp" "$top/bcc/cc1" "$top/copt/copt" "$top/copt/rules.6809" \
	"$top/unproto/unproto" "$prefix/libexec/bcc09/"
ln -s "$top/libc/libc.a" "$top/libc/include" "$top/libc/crtsim.o" \
	"$top/libc/libsim.a" "$prefix/share/bcc09/"
export BCC_PREFIX=$prefix
unset BCC_EXEC_PREFIX
cd "$work" || exit 1

python3 -I - > ops.h << 'EOF'
import random, struct
rng = random.Random(6809)
def r():
    return rng.choice([1, -1]) * rng.uniform(1, 2) * 2.0 ** rng.randint(-20, 20)
def f(x):
    return struct.unpack('f', struct.pack('f', x))[0]
for name, ctype, gen in (("da", "double", r), ("db", "double", r),
                         ("fa", "float", lambda: f(r())),
                         ("fb", "float", lambda: f(r())),
                         ("la", "long", lambda: rng.randint(-2**31, 2**31 - 1))):
    print("%s %s[64] = {%s};" % (ctype, name, ", ".join(repr(gen()) for _ in range(64))))
EOF
cat > bench.c << 'EOF'
#include "ops.h"
double dr; float fr; long lr; int ir;
int main()
{
	int i;
	for (i = 0; i < 64; i++) {
		BODY;
	}
	return 0;
}
EOF

# the cycles the program with BODY $1 takes
cycles() {
	"$prefix/bin/bcc09" -Mi -o b.out -X-T0x1000 "-DBODY=$1" bench.c \
		> /dev/null 2>&1 &&
	"$prefix/bin/objcopy09" -O srec b.out b.srec &&
	"$SIM" --cycles b.srec 2>&1 > /dev/null < /dev/null |
		sed -n 's/^.*: \([0-9]*\) cycles.*/\1/p'
}
dbase=$(cycles 'dr = da[i]')
fbase=$(cycles 'fr = fa[i]')
lbase=$(cycles 'lr = la[i]')
[ -n "$dbase" ] && [ -n "$fbase" ] && [ -n "$lbase" ] || {
	echo "fpbench.sh: building or running failed" >&2
	exit 1
}
row() {		# $1 = what, $2 = statement, $3 = the loop's own cycles
	printf "%-28s %6d\n" "$1" $(( ($(cycles "$2") - $3) / 64 ))
}
row "double +"          'dr = da[i] + db[i]' $dbase
row "double -"          'dr = da[i] - db[i]' $dbase
row "double *"          'dr = da[i] * db[i]' $dbase
row "double /"          'dr = da[i] / db[i]' $dbase
row "double <"          'ir = da[i] < db[i]' $dbase
row "float +"           'fr = fa[i] + fb[i]' $fbase
row "float *"           'fr = fa[i] * fb[i]' $fbase
row "float /"           'fr = fa[i] / fb[i]' $fbase
row "double to long"    'lr = da[i]' $dbase
row "long to double"    'dr = la[i]' $lbase
row "float to double"   'dr = fa[i]' $fbase
row "double to float"   'fr = da[i]' $dbase
