#!/usr/bin/env python3
"""Print the MC6809's fields from an XRoar snapshot (field number: value).
Each field is: number, length, value (a variable-length unsigned integer:
the number of leading 1 bits in the first byte is how many bytes follow),
then a 0."""
import sys
snap = open(sys.argv[1], 'rb').read()
i = snap.find(b'\x03CPU\x02\x06MC6809')
if i < 0:
    sys.exit("no MC6809 state")
i += len(b'\x03CPU\x02\x06MC6809')

def vuint(b):
    n = 0
    first = b[0]
    mask = 0x80
    while first & mask:
        n += 1
        mask >>= 1
    v = first & (mask - 1)
    for x in b[1:1 + n]:
        v = (v << 8) | x
    return v

fields = {}
while snap[i] != 0:
    tag, ln = snap[i], snap[i + 1]
    val = snap[i + 2: i + 2 + ln]
    fields[tag] = vuint(val)
    i += 2 + ln + 1		# the field, and its 0
for t in sorted(fields):
    print('%02x: %04x' % (t, fields[t]))
