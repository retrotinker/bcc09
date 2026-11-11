VERSION=0.13.0

PREFIX=/usr/local
MANDIR=$(PREFIX)/share/man

DIRS=ar as bcc copt cpp ld unproto libc

.PHONY: all check check-xroar check-nitros9 check-flex check-vectrex docs clean \
	install \
	rpm srpm FORCE

all: $(DIRS)
	for i in $^ ;\
	do \
		$(MAKE) PREFIX=$(PREFIX) VERSION=$(VERSION) -C $$i || exit 1 ;\
	done

# regression tests: compare outputs with the references in tests/ref,
# and run programs on sim6809, from the sim6809 project
# (https://github.com/retrotinker/sim6809), found on PATH (SIM6809= names
# another)
SIM6809 ?= sim6809
export SIM6809

check: all
	tests/run.sh
	tests/man.sh

# optional: the Color BASIC target on real ROMs, in the XRoar emulator
check-xroar: all
	tests/xroar/run.sh

check-nitros9: all
	tests/nitros9/run.sh

check-flex: all
	tests/flex/run.sh

# optional: the Vectrex target in MAME
check-vectrex: all
	tests/vectrex/run.sh

# the user's manual, doc/manual.pdf (with pandoc and xelatex): run after
# changing doc/manual.md or a man page, and commit the PDF
docs: doc/manual.pdf doc/basic.pdf FAQ.md

# the FAQ, the manual's chapter "Questions and answers" on its own
FAQ.md: doc/manual.md doc/mkfaq.sh
	doc/mkfaq.sh

doc/manual.pdf: doc/manual.md doc/man/*.1 doc/mkmanual.sh doc/tex/*.sty
	doc/mkmanual.sh

# and "bcc09 for BASIC Programmers"
doc/basic.pdf: doc/basic.md doc/mkbasic.sh doc/tex/*.sty
	doc/mkbasic.sh

# There is bound to be some more clever way to do this than copying
# the "all" rule...
clean: $(DIRS)
	for i in $^ ;\
	do \
		$(MAKE) PREFIX=$(PREFIX) -C $$i clean || exit 1 ;\
	done
	rm -rf rpmbuild

install: $(DIRS)
	for i in $^ ;\
	do \
		$(MAKE) PREFIX=$(PREFIX) VERSION=$(VERSION) \
			LIBEXECDIR=$(PREFIX)/libexec/bcc09 \
			-C $$i install || exit 1 ;\
	done
	install -d $(DESTDIR)$(MANDIR)/man1
	install -m 644 doc/man/*.1 $(DESTDIR)$(MANDIR)/man1

# Fedora RPMs, in rpmbuild/.  The tarball is the release tag v$(VERSION),
# the same files as the GitHub archive the spec's Source0 names, or HEAD
# while VERSION isn't tagged yet; the spec itself comes from the work tree.
RPMTOP=$(CURDIR)/rpmbuild
TARBALL=$(RPMTOP)/SOURCES/bcc09-$(VERSION).tar.gz
RPMTREE=$(shell git rev-parse -q --verify refs/tags/v$(VERSION) >/dev/null && echo v$(VERSION) || echo HEAD)

$(TARBALL): FORCE
	mkdir -p $(RPMTOP)/SOURCES
	@echo "bcc09-$(VERSION).tar.gz from $(RPMTREE)"
	git archive --format=tar.gz --prefix=bcc09-$(VERSION)/ -o $@ $(RPMTREE)
	cp -p bcc09.rpmlintrc $(RPMTOP)/SOURCES/

rpm: $(TARBALL)
	rm -rf $(RPMTOP)/RPMS $(RPMTOP)/SRPMS
	rpmbuild -ba --define "_topdir $(RPMTOP)" bcc09.spec

srpm: $(TARBALL)
	rpmbuild -bs --define "_topdir $(RPMTOP)" bcc09.spec
