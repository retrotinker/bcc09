#!/bin/sh
#
# Makes doc/os9.pdf (make docs), "bcc09 for OS-9 Programmers",
# from doc/os9.md, by pandoc and xelatex, as mkbasic.sh makes the
# BASIC guide.
# (tests/run.sh compiles the complete programs in it.)

top=$(cd "$(dirname "$0")/.." && pwd)
doc=$top/doc
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

for prog in pandoc xelatex; do
	if ! command -v $prog > /dev/null 2>&1; then
		echo "mkos9: no $prog" >&2
		exit 1
	fi
done

cp "$doc/os9.md" "$work/os9.md"
cd "$work" &&
	TEXINPUTS=$doc/tex//: pandoc os9.md -o os9.pdf \
		--pdf-engine=xelatex &&
	cp os9.pdf "$doc/os9.pdf"
