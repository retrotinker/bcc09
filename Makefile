VERSION=0.8.0

PREFIX=/usr/local/bcc09
MANDIR=$(PREFIX)/share/man

DIRS=ar as bcc copt cpp ld unproto libc

.PHONY: all check check-xroar check-nitros9 check-flex docs clean install \
	rpm srpm FORCE

all: $(DIRS)
	for i in $^ ;\
	do \
		$(MAKE) PREFIX=$(PREFIX) -C $$i || exit 1 ;\
	done

# regression tests: compare outputs with the references in tests/ref,
# and run programs on sim6809 (from the plm09 project; see tests/sim)
SIM=tests/sim/sim6809

check: all $(SIM)
	tests/run.sh
	tests/man.sh

# optional: the Color BASIC target on real ROMs, in the XRoar emulator
check-xroar: all
	tests/xroar/run.sh

check-nitros9: all
	tests/nitros9/run.sh

check-flex: all
	tests/flex/run.sh

# the user's manual, doc/manual.pdf (with pandoc and xelatex): run after
# changing doc/manual.md or a man page, and commit the PDF
docs: doc/manual.pdf

doc/manual.pdf: doc/manual.md doc/man/*.1 doc/mkmanual.sh doc/tex/*.sty
	doc/mkmanual.sh

$(SIM): tests/sim/*.c tests/sim/*.h
	$(CC) -std=c11 -O2 -DPLM09_VERSION='"0.4.6"' -o $@ tests/sim/*.c

# There is bound to be some more clever way to do this than copying
# the "all" rule...
clean: $(DIRS)
	for i in $^ ;\
	do \
		$(MAKE) PREFIX=$(PREFIX) -C $$i clean || exit 1 ;\
	done
	rm -f $(SIM)
	rm -rf rpmbuild

install: $(DIRS)
	for i in $^ ;\
	do \
		$(MAKE) PREFIX=$(PREFIX) LIBEXECDIR=$(PREFIX)/libexec/bcc09 \
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
