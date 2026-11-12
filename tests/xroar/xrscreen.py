#!/usr/bin/env python3
"""Print the CoCo text screen ($0400-$05FF, 32x16) from an XRoar snapshot.
usage: xrscreen.py [-g] SNAPSHOT PROGRAM.bin LOADADDR
The RAM image is found in the snapshot by looking for the program's own
bytes, which were loaded at LOADADDR.  With -g, a semigraphics byte
(bit 7 set) is shown as its colour, 0 to 7, if its four quarters are all
lit, and as a blank if none is (otherwise as the text it would be)."""
import sys
args = sys.argv[1:]
graphics = args[:1] == ['-g']
if graphics:
    args = args[1:]
snap = open(args[0], 'rb').read()
binf = open(args[1], 'rb').read()
load = int(args[2], 0)
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
        if graphics and b & 0x80 and b & 0x0f in (0, 0x0f):
            line += str((b >> 4) & 7) if b & 0x0f else ' '
            continue
        v = b & 0x3f
        c = chr(v + 0x40) if v < 0x20 else chr(v)
        line += c if b & 0x40 else c.lower()   # inverse: lower case
    print(line.rstrip())
