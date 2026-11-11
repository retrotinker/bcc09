#!/bin/sh
#
# Writes FAQ.md (make docs) from the manual's chapter "Questions and
# answers" (doc/manual.md), which is where to change it: a heading, then
# the chapter as it is.  With -c, checks that FAQ.md is what it would
# write (tests/run.sh does), instead of writing it.  Needs only awk.

top=$(cd "$(dirname "$0")/.." && pwd)

faq() {
	cat << 'HEAD'
bcc09: questions and answers
============================

The answers to the questions newcomers to bcc09 usually have.  This is
chapter 10 of the user's manual (doc/manual.pdf, from doc/manual.md,
where it is kept): the section and chapter numbers are the manual's.

HEAD
	awk '/^# Questions and answers$/ { f = 1; next }
	     f && /^# / { exit }
	     f' "$top/doc/manual.md" | sed '1{/^$/d;}'
}

if [ "${1:-}" = "-c" ]; then
	faq | cmp -s - "$top/FAQ.md"
	exit
fi
faq > "$top/FAQ.md"
