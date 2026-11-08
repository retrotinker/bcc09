#!/usr/bin/env python3
"""Print the CoCo text screen ($0400-$05FF, 32x16) from an XRoar snapshot.
usage: xrscreen.py SNAPSHOT PROGRAM.bin LOADADDR
The RAM image is found in the snapshot by looking for the program's own
bytes, which were loaded at LOADADDR."""
import sys
snap = open(sys.argv[1], 'rb').read()
binf = open(sys.argv[2], 'rb').read()
load = int(sys.argv[3], 0)
# a DECB BIN: 0x00, length (2), address (2), data...
assert binf[0] == 0
code = binf[5:5 + 32]
off = snap.find(code)
if off < 0:
    sys.exit("program not found in snapshot")
base = off - load
screen = snap[base + 0x400: base + 0x600]
for row in range(16):
    line = ''
    for b in screen[row * 32:(row + 1) * 32]:
        v = b & 0x3f
        c = chr(v + 0x40) if v < 0x20 else chr(v)
        line += c if b & 0x40 else c.lower()   # inverse: lower case
    print(line.rstrip())
