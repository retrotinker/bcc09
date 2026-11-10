#!/usr/bin/env python3
"""Write tests/src/fpdata.h: operands and expected results of IEEE double
and float arithmetic, comparisons and conversions, for tests/src/fptest.c,
from Python's own doubles (IEEE 754, rounding to the nearest) and an exact
model of rounding to float, independent of bcc09.

Every value is in 16-bit words, high word first, as bcc09 stores it.  A
NaN result is any NaN (the sign and payload aren't checked).  Conversions
to integers are only of values in the type's range (C leaves the rest
undefined).

usage: gen-fpdata.py > src/fpdata.h
"""

import math
import random
import struct
from fractions import Fraction

INF = float("inf")
NAN = float("nan")

SPECIALS = [0.0, -0.0, 1.0, -1.0, 1.5, 0.1, -3.75, 1e300, 2.0 ** -1074,
            -2.0 ** -1022, 1.7976931348623157e308, INF, -INF, NAN]


def dwords(x):
    b = struct.pack(">d", x)
    return [int.from_bytes(b[i:i + 2], "big") for i in range(0, 8, 2)]


def fwords(x):
    """x, which must be a float exactly, as a float's 2 words"""
    b = struct.pack(">f", x)
    return [int.from_bytes(b[i:i + 2], "big") for i in range(0, 4, 2)]


def f32(x):
    """x rounded to float (to the nearest, even on a tie), as a double"""
    if math.isnan(x) or math.isinf(x) or x == 0:
        return x
    q = Fraction(abs(x))
    e = math.frexp(abs(x))[1] - 1	# the leading bit's exponent
    p = 24 if e >= -126 else 24 - (-126 - e)	# bits a float has here
    if p < 0:
        return math.copysign(0.0, x)
    s = q * Fraction(2) ** (p - 1 - e)
    n = math.floor(s)
    r = s - n
    if r > Fraction(1, 2) or (r == Fraction(1, 2) and n % 2 == 1):
        n += 1
    v = Fraction(n) * Fraction(2) ** (e - p + 1)
    if v >= 2 ** 128:
        return math.copysign(INF, x)
    return math.copysign(float(v), x)


def rdouble(rng, lo, hi):
    """a random double with an exponent from lo to hi"""
    # (the tables must fit below sim6809's stack, which simcrt0.s puts at
    # $7F00: fptest is built at $1000)
    e = rng.randint(lo, hi)
    m = rng.getrandbits(52) | (1 << 52)
    return rng.choice([1, -1]) * math.ldexp(m, e - 52)


def nanw(w):
    return [0x7FF8, 0, 0, 0] if (w[0] & 0x7FF0) == 0x7FF0 and \
        (w[0] & 0xF or w[1] or w[2] or w[3]) else w


def op(f, a, b):
    try:
        r = f(a, b)
    except ZeroDivisionError:
        if math.isnan(a) or a == 0:
            r = NAN
        else:
            r = math.copysign(INF, a) * math.copysign(1, b)
    except OverflowError:
        r = INF
    return r


def mul(a, b):
    r = a * b
    return r


def div(a, b):
    return a / b


def cmp(a, b):
    if math.isnan(a) or math.isnan(b):
        return 2
    return (a > b) - (a < b)


def words(name, rows):
    out = ["unsigned %s[] = {" % name]
    for r in rows:
        out.append("\t" + ", ".join("0x%04X" % w for w in r) + ",")
    out.append("};")
    return "\n".join(out)


def ints(name, vals, ctype="int"):
    out = ["%s %s[] = {" % (ctype, name)]
    for i in range(0, len(vals), 6):
        out.append("\t" + ", ".join(str(v) for v in vals[i:i + 6]) + ",")
    out.append("};")
    return "\n".join(out)


def main():
    rng = random.Random(6809)
    pairs = [(a, b) for a in SPECIALS for b in SPECIALS]
    for i in range(24):		# moderate sizes
        pairs.append((rdouble(rng, -20, 20), rdouble(rng, -20, 20)))
    for i in range(12):		# far apart, and near the ends
        pairs.append((rdouble(rng, -1074, 1023), rdouble(rng, -1074, 1023)))
    for i in range(12):		# close together: cancellation
        a = rdouble(rng, -10, 10)
        pairs.append((a, -a * (1 + rng.choice([1, -1]) *
                                math.ldexp(rng.getrandbits(8), -52))))
    for i in range(6):		# denormals
        pairs.append((rdouble(rng, -1074, -1020), rdouble(rng, -1074, -1020)))
    # ties when adding: round to even
    pairs += [(1.0, 2.0 ** -53), (1.0 + 2.0 ** -52, 2.0 ** -53),
              (1.0, -2.0 ** -54), (2.0 ** 53, 1.0), (2.0 ** 53, 3.0),
              (1.0 / 3, 3.0), (2.0 / 3, 1.5), (1e308, 10.0), (1e-308, 1e10),
              (2.0 ** -1022, 0.5), (3.0, 2.0 ** -1074),
              # a full mantissa times short ones (whose bytes of 0 the
              # multiplication leaves out), both ways round
              (1 + 2.0 ** -52, 1.25), (0.75, 1 - 2.0 ** -53)]

    rows = []
    for a, b in pairs:
        r = dwords(a) + dwords(b)
        for f in (lambda x, y: x + y, lambda x, y: x - y, mul, div):
            r += nanw(dwords(op(f, a, b)))
        c = cmp(a, b)
        r.append(c & 0xFFFF)
        rows.append(r)

    # float arithmetic: floats, and the results rounded to float
    fl = [f32(x) for x in [0.0, 1.0, -1.5, 0.1, 3.4e38, 1e-45, 1e-40,
                          -2.5e-20, 16777216.0, 1.0 / 3, INF, NAN]]
    for i in range(16):
        fl.append(f32(rdouble(rng, -30, 30)))
    frows = []
    for a in [fl[i] for i in (0, 2, 3, 4, 5, 8, 10, 11)]:
        for b in fl:
            r = fwords(a) + fwords(b)
            for f in (lambda x, y: x + y, lambda x, y: x - y, mul, div):
                v = op(f, a, b)
                v = f32(v)
                w = fwords(v) if not math.isnan(v) else [0x7FC0, 0]
                r += w
            frows.append(r)

    # doubles to floats, and floats to doubles
    dl = [0.0, -0.0, 1.0, 0.1, -0.1, 1.0 / 3, 3.4028235677973366e38,
          3.4028234663852886e38, 3.402823567797337e38, 1e39, -1e39,
          1.1754943508222875e-38, 1.401298464324817e-45, 7e-46, 7.006e-46,
          1e-50, 2.0 ** -149 * 1.5, 2.0 ** -149 * 2.5, 1 + 2.0 ** -24,
          1 + 3 * 2.0 ** -24, 1 + 2.0 ** -24 + 2.0 ** -40, 16777217.0,
          16777219.0, 123456789.0, INF, -INF, NAN, 1e300, 2.0 ** -1074,
          # just over half, by the last bit of all
          1 + 2.0 ** -24 + 2.0 ** -52, -(1 + 3 * 2.0 ** -24 - 2.0 ** -52)]
    for i in range(20):
        dl.append(rdouble(rng, -160, 130))
    dfrows = []
    for x in dl:
        v = f32(x)
        dfrows.append(dwords(x) + (fwords(v) if not math.isnan(v)
                                   else [0x7FC0, 0]))
    fdrows = [fwords(x) + nanw(dwords(x)) for x in fl]

    # doubles to integers (in range), and integers to doubles
    toi = [0.0, -0.0, 0.5, -0.5, 0.99, -0.99, 1.0, -1.0, 1.5, -2.5,
           32767.0, 32767.9, -32768.0, -32768.9, 12345.678, -9999.99,
           2.0 ** -1074, 1e-300]
    tol = toi + [2147483647.0, 2147483647.5, -2147483648.0,
                 -2147483648.75, 1e9, -123456789.9, 65536.5, 16777217.0]
    toui = [0.0, 0.9, 1.0, 40000.0, 65535.0, 65535.99, 32768.5, 1234.5]
    toul = toui + [4294967295.0, 4294967295.5, 3e9, 2147483648.0,
                   65536.0 * 65535]
    itod = [0, 1, -1, 7, -7, 255, 32767, -32768, 12345, -1000]
    uitod = [0, 1, 32768, 40000, 65535]
    ltod = [0, 1, -1, 65536, -65536, 2147483647, -2147483648,
            123456789, -987654321, 16777217, 16777219]
    ultod = [0, 1, 2147483648, 4294967295, 3000000000, 16777217]

    print("/* generated by tests/gen-fpdata.py: don't edit */")
    print()
    print("/* pairs of doubles: a, b, a + b, a - b, a * b, a / b, then")
    print("   -1, 0 or 1 as a <, ==, > b, or 2 if they are unordered */")
    print("#define NPAIRS %d" % len(rows))
    print(words("dpairs", rows))
    print()
    print("/* pairs of floats: a, b, then a + b ... a / b as floats */")
    print("#define NFPAIRS %d" % len(frows))
    print(words("fpairs", frows))
    print()
    print("/* doubles, and as floats; floats, and as doubles */")
    print("#define NDTOF %d" % len(dfrows))
    print(words("dtoft", dfrows))
    print("#define NFTOD %d" % len(fdrows))
    print(words("ftodt", fdrows))
    print()
    print("/* doubles, and as ints; ... longs; ... unsigned; ... unsigned longs */")
    for name, vals, conv, ctype in (
            ("toi", toi, lambda x: int(x), "int"),
            ("tol", tol, lambda x: int(x), "long"),
            ("toui", toui, lambda x: int(x), "unsigned"),
            ("toul", toul, lambda x: int(x), "unsigned long")):
        print("#define N%s %d" % (name.upper(), len(vals)))
        print(words(name + "d", [dwords(x) for x in vals]))
        suffix = {"int": "", "long": "L", "unsigned": "U",
                  "unsigned long": "UL"}[ctype]
        print(ints(name + "v", ["%d%s" % (conv(x), suffix) if conv(x) >= 0 or
                                ctype != "long" or conv(x) > -2147483648
                                else "(-2147483647L - 1)"
                                for x in vals], ctype))
    print()
    print("/* integers, and as doubles */")
    for name, vals, ctype, suffix in (
            ("itod", itod, "int", ""), ("uitod", uitod, "unsigned", "U"),
            ("ltod", ltod, "long", "L"),
            ("ultod", ultod, "unsigned long", "UL")):
        print("#define N%s %d" % (name.upper(), len(vals)))
        lits = []
        for v in vals:
            if ctype == "int" and v == -32768:
                lits.append("(-32767 - 1)")
            elif ctype == "long" and v == -2147483648:
                lits.append("(-2147483647L - 1)")
            else:
                lits.append("%d%s" % (v, suffix))
        print(ints(name + "v", lits, ctype))
        print(words(name + "d", [dwords(float(v)) for v in vals]))


main()
