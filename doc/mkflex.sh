#!/bin/sh
#
# Makes doc/flex.pdf (make docs), "bcc09 for FLEX Programmers",
# from doc/flex.md, by pandoc and xelatex, as mkbasic.sh makes the
# BASIC guide.
# (tests/run.sh compiles the complete programs in it.)

top=$(cd "$(dirname "$0")/.." && pwd)
doc=$top/doc
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

for prog in pandoc xelatex; do
	if ! command -v $prog > /dev/null 2>&1; then
		echo "mkflex: no $prog" >&2
		exit 1
	fi
done

cp "$doc/flex.md" "$work/flex.md"
cd "$work" &&
	TEXINPUTS=$doc/tex//: pandoc flex.md -o flex.pdf \
		--pdf-engine=xelatex &&
	cp flex.pdf "$doc/flex.pdf"
