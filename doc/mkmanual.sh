#!/bin/sh
#
# Makes doc/manual.pdf (make docs): doc/manual.md, then, as its Appendix
# A, each program's man page (doc/man, read by pandoc's man reader, its
# sections a level down), by pandoc and xelatex.  doc/tex has a package
# that pandoc's LaTeX template wants and some TeX installations lack.

top=$(cd "$(dirname "$0")/.." && pwd)
doc=$top/doc
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

for prog in pandoc xelatex; do
	if ! command -v $prog > /dev/null 2>&1; then
		echo "mkmanual: no $prog" >&2
		exit 1
	fi
done

# (the pages' sections aren't numbered, as the appendix isn't)
cat > "$work/unnumbered.lua" <<'LUA'
function Header(h)
  h.classes:insert('unnumbered')
  return h
end
LUA
cp "$doc/manual.md" "$work/manual.md"
for p in bcc09 as09 ld09 ar09 objdump09 objcopy09 \
	 bcc09-cpp bcc09-unproto bcc09-cc1 bcc09-copt; do
	printf '\n## %s(1) {.unnumbered}\n\n' "$p" >> "$work/manual.md"
	pandoc -f man -t markdown --shift-heading-level-by=2 \
		--lua-filter="$work/unnumbered.lua" \
		"$doc/man/$p.1" >> "$work/manual.md" || exit 1
done

cd "$work" &&
	TEXINPUTS=$doc/tex//: pandoc manual.md -o manual.pdf \
		--pdf-engine=xelatex &&
	cp manual.pdf "$doc/manual.pdf"
