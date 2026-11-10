#!/bin/sh
#
# Makes doc/basic.pdf (make docs), "bcc09 for BASIC Programmers", from
# doc/basic.md, by pandoc and xelatex, as mkmanual.sh makes the manual.
# (tests/run.sh compiles the complete programs in it.)

top=$(cd "$(dirname "$0")/.." && pwd)
doc=$top/doc
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

for prog in pandoc xelatex; do
	if ! command -v $prog > /dev/null 2>&1; then
		echo "mkbasic: no $prog" >&2
		exit 1
	fi
done

cp "$doc/basic.md" "$work/basic.md"
cd "$work" &&
	TEXINPUTS=$doc/tex//: pandoc basic.md -o basic.pdf \
		--pdf-engine=xelatex &&
	cp basic.pdf "$doc/basic.pdf"
