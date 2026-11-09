#!/bin/sh
#
# Checks of the man pages in doc/man (make check runs it after run.sh):
# each must format with no warnings from "groff -man -ww" (skipped
# without groff), and must name every option its program takes (skipped
# without python3): the programs have no --help to list them, so the
# lists are here, from their sources (bcc/bcc.c's getargs(), as/as.c,
# ld/ld.c, ar/ar.c, ld/objdump86.c, ld/objcopy.c, cpp/main.c,
# bcc/input.c, copt/copt.c; unproto has none): add an option to one
# of those, and it must be added here and to the page.  An option counts
# if the page has it as a whole word, written \- in roff; ar09's keys
# (letters) if a line of the page starts with .B or .BR and has the
# letter as a word.

top=$(cd "$(dirname "$0")/.." && pwd)
man=$top/doc/man

opts_bcc09="-c -S -E -P -o -O -M -x -D -U -I -L -l -X -A -t -C -u -W -kr -ansi -g -p -w -B -T -v -V -e"
opts_as09="-o -b -l -m -s -n -g -u -w -k -t -v"
opts_ld09="-o -T -D -H -i -l -L -C -O -s -y -d -m -M -t -r -v"
keys_ar09="r q d x t p m a b i c u o s v l"
opts_objdump09="-n -s -o"
opts_objcopy09="-O -n -T -D -p -v -d -r"
opts_bcc09_cpp="-A -K -P -D -U -I -o -O -c -f -0 -3 -d -T -C"
opts_bcc09_cc1="-p -u -t -d -w -O -c -f -E -D -U -I -P -o"
opts_bcc09_copt="-f -o -c -d -b -h"
opts_bcc09_unproto=""

failed=0
for p in bcc09 as09 ld09 ar09 objdump09 objcopy09 nm09 size09 \
	 bcc09-cpp bcc09-cc1 bcc09-copt bcc09-unproto; do
	page=$man/$p.1
	if [ ! -f "$page" ]; then
		echo "FAIL man/$p: no doc/man/$p.1"
		failed=$((failed + 1))
		continue
	fi
	case $p in
	nm09|size09)		# (.so links to objdump09.1)
		if [ "$(cat "$page")" != ".so man1/objdump09.1" ]; then
			echo "FAIL man/$p: not a link to objdump09.1"
			failed=$((failed + 1))
		else
			echo "ok   man/$p"
		fi
		continue ;;
	esac
	if command -v groff > /dev/null 2>&1; then
		warn=$(groff -man -ww -z "$page" 2>&1)
		if [ -n "$warn" ]; then
			echo "FAIL man/$p: groff warnings"
			echo "$warn"
			failed=$((failed + 1))
			continue
		fi
	fi
	if command -v python3 > /dev/null 2>&1; then
		v=$(echo "$p" | tr - _)
		eval "opts=\$opts_$v; keys=\$keys_$v"
		missing=$(python3 -I - "$page" "$opts" "$keys" <<'PY'
import re, sys
page = open(sys.argv[1]).read()
for o in sys.argv[2].split():
    roff = re.escape(o.replace("-", "\\-"))
    if not re.search(r"(^|[^-A-Za-z0-9\\])" + roff + r"($|[^-A-Za-z0-9\\])",
                     page, re.M):
        print(o, end=" ")
for k in sys.argv[3].split():
    if not re.search(r'^\.BR? (.*[ "])?' + k + r'([ ",]|$)', page, re.M):
        print(k, end=" ")
PY
)
		if [ -n "$missing" ]; then
			echo "FAIL man/$p: not in the page: $missing"
			failed=$((failed + 1))
			continue
		fi
	fi
	echo "ok   man/$p"
done
command -v groff > /dev/null 2>&1 ||
	echo "(groff isn't here: the pages weren't formatted)"
command -v python3 > /dev/null 2>&1 ||
	echo "(python3 isn't here: the options weren't looked for)"
exit $failed
