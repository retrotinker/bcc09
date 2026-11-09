#!/usr/bin/env python3
"""Check the RS-DOS disk image that xdisk.c and BASIC wrote (see run.sh).
usage: xrdisk.py DISK [nobasic]
It must hold IN.DAT, BIG.DAT (5100 bytes of xdisk.c's pattern), OUT.TXT
(three lines ending with CR) and BAS.DAT (BASIC's "FROM BASIC", unless
nobasic), and not DEL.TXT; and every granule the FAT says is used must
be in exactly one file's chain, each chain ending with the right number
of sectors.
Prints what is wrong, and exits with 1 if anything is."""
import sys

d = open(sys.argv[1], 'rb').read()


def sector(t, s):
    o = (t * 18 + s - 1) * 256
    return d[o:o + 256]


def gran(g):
    t = g // 2 if g // 2 < 17 else g // 2 + 1
    first = (g & 1) * 9 + 1
    return b''.join(sector(t, first + i) for i in range(9))


fat = sector(17, 2)[:68]
bad = []
files = {}
owner = {}
for s in range(3, 12):
    sec = sector(17, s)
    for e in range(8):
        ent = sec[e * 32:e * 32 + 32]
        if ent[0] == 0xff:
            break
        if ent[0] == 0:
            continue
        name = (ent[:8].decode('latin-1').rstrip() + '.' +
                ent[8:11].decode('latin-1').rstrip())
        g, data = ent[13], b''
        for n in range(69):
            if g >= 68:
                bad.append('%s: granule %d' % (name, g))
                break
            if g in owner:
                bad.append('%s: granule %d is %s\'s too' % (name, g, owner[g]))
            owner[g] = name
            c = fat[g]
            if 0xc0 <= c <= 0xc9:
                nsec = c - 0xc0
                last = ent[14] << 8 | ent[15]
                if nsec:
                    data += gran(g)[:(nsec - 1) * 256 + last]
                break
            data += gran(g)
            g = c
        files[name] = data

for g in range(68):
    if fat[g] != 0xff and g not in owner:
        bad.append('granule %d is used but in no file' % g)

expect = {
    'IN.DAT': b'HELLO, DISK\r',
    'BIG.DAT': bytes((i * 7 + i // 251) & 0xff for i in range(5100)),
    'OUT.TXT': b'LINE 1\rLINE 2\rLINE 3\r',
    'BAS.DAT': b'FROM BASIC\r',
}
if len(sys.argv) > 2 and sys.argv[2] == 'nobasic':
    del expect['BAS.DAT']
for name, data in expect.items():
    if name not in files:
        bad.append('no %s' % name)
    elif files[name] != data:
        bad.append('%s: %r' % (name, files[name][:40]))
for name in files:
    if name not in expect:
        bad.append('%s is there' % name)

for b in bad:
    print(b)
sys.exit(1 if bad else 0)
