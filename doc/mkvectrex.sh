#!/bin/sh
#
# Makes doc/vectrex.pdf (make docs), "bcc09 for Vectrex Programmers",
# from doc/vectrex.md, by pandoc and xelatex, as mkbasic.sh makes the
# BASIC guide.
# (tests/run.sh compiles the complete programs in it.)

top=$(cd "$(dirname "$0")/.." && pwd)
doc=$top/doc
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

for prog in pandoc xelatex; do
	if ! command -v $prog > /dev/null 2>&1; then
		echo "mkvectrex: no $prog" >&2
		exit 1
	fi
done

cp "$doc/vectrex.md" "$work/vectrex.md"
cd "$work" &&
	TEXINPUTS=$doc/tex//: pandoc vectrex.md -o vectrex.pdf \
		--pdf-engine=xelatex &&
	cp vectrex.pdf "$doc/vectrex.pdf"
